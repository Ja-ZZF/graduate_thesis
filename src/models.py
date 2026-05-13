import torch
import torch.nn as nn
import torch.nn.functional as F
from torchvision.models import mobilenet_v3_small

# =========================================================
# Dynamic Depthwise Convolution (核心创新点)
# =========================================================
class DynamicDWConv(nn.Module):
    """
    Dynamic Receptive Field Depthwise Convolution
    3x3 + 5x5 adaptive fusion
    """

    def __init__(self, channels):
        super().__init__()

        # 3x3 depthwise conv
        self.dw3 = nn.Conv2d(
            channels,
            channels,
            kernel_size=3,
            padding=1,
            groups=channels,
            bias=False
        )

        # 5x5 depthwise conv
        self.dw5 = nn.Conv2d(
            channels,
            channels,
            kernel_size=5,
            padding=2,
            groups=channels,
            bias=False
        )

        # attention for kernel selection
        self.pool = nn.AdaptiveAvgPool2d(1)

        self.fc = nn.Sequential(
            nn.Linear(channels, channels // 4),
            nn.ReLU(inplace=True),
            nn.Linear(channels // 4, 2)
        )

        self.softmax = nn.Softmax(dim=1)

    def forward(self, x):

        b, c, h, w = x.shape

        x3 = self.dw3(x)
        x5 = self.dw5(x)

        # global context
        attn = self.pool(x).view(b, c)

        attn = self.fc(attn)
        attn = self.softmax(attn)

        w3 = attn[:, 0].view(b, 1, 1, 1)
        w5 = attn[:, 1].view(b, 1, 1, 1)

        return w3 * x3 + w5 * x5


# =========================================================
# Replace Depthwise Conv in MobileNetV3
# =========================================================
def replace_dwconv_with_dynamic(model):

    for module in model.modules():

        if hasattr(module, "block"):

            for i, layer in enumerate(module.block):

                # 找 depthwise conv
                if hasattr(layer, "conv"):

                    for j, sublayer in enumerate(layer.conv):

                        if isinstance(sublayer, nn.Conv2d) and sublayer.groups == sublayer.in_channels:

                            channels = sublayer.in_channels

                            module.block[i].conv[j] = DynamicDWConv(channels)

    return model


# =========================================================
# FER Model
# =========================================================
class DynamicMobileNetV3Small(nn.Module):

    def __init__(self, num_classes=8, pretrained=True):

        super().__init__()

        weights = "DEFAULT" if pretrained else None

        self.backbone = mobilenet_v3_small(weights=weights)

        # =================================================
        # Dynamic Receptive Field (ONLY innovation)
        # =================================================
        self.backbone = replace_dwconv_with_dynamic(self.backbone)

        # =================================================
        # Classifier (unchanged structure, just adapt classes)
        # =================================================
        in_features = self.backbone.classifier[0].in_features

        self.backbone.classifier = nn.Sequential(

            nn.Linear(in_features, 512),
            nn.Hardswish(),
            nn.Dropout(0.3),
            nn.Linear(512, num_classes)
        )

    def forward(self, x):

        return self.backbone(x)


# =========================================================
# Test
# =========================================================
if __name__ == "__main__":

    model = DynamicMobileNetV3Small(num_classes=8)

    x = torch.randn(2, 3, 224, 224)

    y = model(x)

    print("Output shape:", y.shape)
