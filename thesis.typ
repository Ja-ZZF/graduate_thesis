#import "@preview/shuosc-shu-bachelor-thesis:1.0.0": documentclass, algox, tablex, citex, imagex, subimagex

#let (
  info,
  doc,
  cover,
  declare,
  appendix,
  outline,
  mainmatter,
  conclusion,
  abstract,
  bib,
  acknowledgement,
  under-cover,
  fonts,
) = documentclass(
  info: (
    title: "基于轻量化神经网络的表情识别系统",
    school: "计算机工程与科学学院",
    major: "计算机科学与技术",
    student_id: "22122742",
    name: "朱子凡",
    supervisor: "费子翔",
    date: "2026年2月31日起5月32日止",
  ),
  fonts: (
    fallback: false, // 为true时字体缺失时使用系统默认，不显示豆腐块
    // 模版内置了一定的字体调用顺序，但可能与系统的不一致，出现这种情况是先在Tinyminst->Tool->Fonts的字体库中找到字体名称，然后在下面填入即可
    // 可以配置的字体有：songti, heiti, kaiti, fangsong, dengkuan
    // 正文为songti，标题为heiti，代码为dengkuan
    // 下面是使用示例：
    songti: (
      (name: "Times New Roman", covers: "latin-in-cjk"), // 先指定英文字体
      "簡宋", // 中文字体
    ),
  ),
  title-line-length: 260pt, // 如果题目换行不好看，可以在这里适当修改换行的长度
  math-level: 2, // 选择公式编号层级
  outline-compact: false, // true目录是紧凑的形式；false按照学校的方式
  citation: (
    func: bibliography("ref.bib"), // 参考文献源文件，主流的论文网站（谷歌学术，知网等）都会提供bibtex格式的参考文献
    full: false, // false表示只显示已引用的文献，不显示未引用的文献；true表示显示所有文献
    sup: true, // true表示行内标注默认为上角标；false表示行内标注默认占据整行
  ),
)

// 设置文档格式
#fonts
#show: doc

// 显示封面
#cover()

// 显示声明
#declare(
  author-sign: image("figures/sign.png"), // 学生签名
  supervisor-sign: image("figures/sign.png"), // 教师签名
  date: none, // 日期为空则默认为当天
)

#abstract(
  keywords: ("轻量化神经网络", "模型压缩", "实时识别", "移动计算"),
  keywords-en: ("lightweight neural network", "model compression", "real-time recognition", "mobile computing"),
)[
  随着人工智能与计算机视觉技术的快速发展，人脸表情识别在智能监控、人机交互、在线教育以及医疗辅助等领域具有广泛的应用前景。然而，传统深度卷积神经网络虽然能够取得较高的识别精度，但普遍存在模型参数量大、计算复杂度高、部署成本高等问题，难以满足边缘设备和实时场景下的应用需求。因此，研究一种兼顾识别精度与轻量化特性的表情识别模型具有重要意义。

  本文围绕轻量化人脸表情识别任务展开研究，构建了一种基于轻量化神经网络的表情识别系统。首先，选取 FerPlus 与 RAF-DB 两个主流表情识别数据集作为实验基础，并针对原始图像分辨率较低、光照变化明显等问题，设计了一套数据预处理流程。该流程通过超分辨率重建技术将图像由 48×48 提升至 224×224，同时结合 CLAHE（Contrast Limited Adaptive Histogram Equalization）进行光照增强，并在训练阶段引入随机翻转、随机裁剪等数据增强策略，从而提升模型对复杂环境下表情特征的鲁棒性。

  在模型设计方面，本文对 ResNet18、ResNet18+CBAM、ResNet18+ViT、MobileNetV1、MobileNetV2 以及 MobileNetV3Small 等多种主流轻量化网络进行了对比研究。在此基础上，提出了一种 Dynamic-MobileNetV3Small 模型。该模型以 MobileNetV3Small 为主干网络，在深度可分离卷积结构中引入动态感受野模块，通过并行的 3×3 与 5×5 Depthwise Convolution 提取不同尺度的表情特征，并利用自适应权重融合机制动态调整不同感受野的重要性，使模型能够针对不同表情自动关注更加有效的局部区域，从而增强多尺度表情特征建模能力。

  实验结果表明，本文提出的 Dynamic-MobileNetV3Small 模型在保持较低计算复杂度的同时，实现了较高的识别准确率。在仅约 0.05 GFLOPs 的计算量条件下，模型在测试集上取得了 82.28% 的总体识别准确率，计算量略低于 MobileNetV3Small，而识别精度优于原始模型，验证了所提出方法在轻量化与识别性能之间具有较好的平衡能力。

][
  With the rapid development of artificial intelligence and computer vision technology, facial expression recognition has shown broad application prospects in intelligent surveillance, human-computer interaction, online education, and medical assistance. However, although traditional deep convolutional neural networks can achieve high recognition accuracy, they generally suffer from large parameter sizes, high computational complexity, and expensive deployment costs, making them difficult to apply in edge devices and real-time scenarios. Therefore, it is of great significance to study a facial expression recognition model that balances both recognition accuracy and lightweight characteristics.

  This thesis focuses on lightweight facial expression recognition and constructs an expression recognition system based on lightweight neural networks. First, the FerPlus and RAF-DB datasets are selected as the experimental basis. To address the problems of low image resolution and illumination variations in the original datasets, a data preprocessing pipeline is designed. The preprocessing process employs super-resolution reconstruction to upscale facial images from 48×48 to 224×224, while CLAHE (Contrast Limited Adaptive Histogram Equalization) is applied for illumination enhancement. In addition, random data augmentation strategies such as random flipping and random cropping are introduced during training to improve the robustness of the model under complex environments.

  In terms of model design, several mainstream lightweight neural networks, including ResNet18, ResNet18+CBAM, ResNet18+ViT, MobileNetV1, MobileNetV2, and MobileNetV3Small, are comparatively studied. Based on these models, a Dynamic-MobileNetV3Small model is proposed. The proposed model adopts MobileNetV3Small as the backbone network and introduces a dynamic receptive field module into the depthwise separable convolution structure. By utilizing parallel 3×3 and 5×5 depthwise convolutions, the model extracts multi-scale facial expression features, while an adaptive weight fusion mechanism dynamically adjusts the importance of different receptive fields. As a result, the model can automatically focus on more effective local regions for different facial expressions, thereby enhancing multi-scale feature representation capability.

  Experimental results demonstrate that the proposed Dynamic-MobileNetV3Small model achieves high recognition accuracy while maintaining low computational complexity. With only about 0.05 GFLOPs computational cost, the proposed model achieves an overall recognition accuracy of 82.28% on the test set. Compared with the original MobileNetV3Small model, the proposed method achieves slightly lower computational complexity and higher recognition accuracy, verifying its effectiveness in balancing lightweight design and recognition performance.

]
// 显示目录
#outline()

// 设置文档主体的格式
#show: mainmatter


= 绪论

== 研究背景与意义

=== 人脸表情识别的发展现状

人脸表情是人类情感表达的重要方式之一。心理学研究表明，在人与人的交流过程中，面部表情能够传递大量情绪与行为信息，因此对人脸表情进行自动识别具有重要的理论意义与应用价值。随着人工智能、计算机视觉以及深度学习技术的快速发展，人脸表情识别（Facial Expression Recognition，FER）逐渐成为智能感知领域的重要研究方向，并广泛应用于智能监控、人机交互、在线教育、驾驶行为分析以及医疗辅助等场景。

传统的人脸表情识别方法主要包括人脸检测、特征提取与分类识别三个阶段。早期研究通常采用人工设计特征的方法，例如局部二值模式（LBP）、方向梯度直方图（HOG）、Gabor 小波特征等。这类方法具有实现简单、计算量较小等优点，但由于其特征表达能力有限，容易受到光照变化、遮挡、姿态变化以及个体差异等因素影响，因此在复杂场景中的识别效果较差。

近年来，深度学习技术的兴起极大推动了表情识别领域的发展。卷积神经网络（CNN）能够通过多层卷积结构自动学习图像深层语义特征，相比传统方法具有更强的特征提取能力。以 AlexNet、VGGNet、ResNet 为代表的深度卷积网络在多个公开表情识别数据集上取得了较高准确率。与此同时，Transformer 结构与注意力机制逐渐被引入表情识别任务，通过增强模型对关键区域的关注能力进一步提升识别性能。

然而，随着网络深度不断增加，模型参数量与计算复杂度也迅速提升。高性能模型通常需要大量计算资源支持，难以直接部署于移动端与嵌入式设备中。因此，如何在保证识别精度的同时降低模型复杂度与计算开销，逐渐成为当前表情识别研究中的重点问题。

=== 轻量化神经网络的发展趋势

随着移动互联网、物联网以及边缘计算技术的不断发展，深度学习模型逐渐从高性能服务器向移动终端与边缘设备迁移。然而，传统深度卷积神经网络通常存在参数量庞大、计算复杂度高以及推理速度慢等问题，难以满足实时应用需求。因此，轻量化神经网络逐渐成为深度学习领域的重要研究方向。

轻量化网络的核心目标是在减少模型参数量与计算量的同时，尽可能保持较高的识别性能。目前主流的轻量化方法主要包括深度可分离卷积、模型剪枝、参数量化以及知识蒸馏等。其中，以 MobileNet、ShuffleNet 与 EfficientNet 为代表的轻量化卷积神经网络在移动端视觉任务中得到了广泛应用。

MobileNetV1 首次提出深度可分离卷积结构，将标准卷积分解为 Depthwise Convolution 与 Pointwise Convolution，大幅减少了模型计算量。MobileNetV2 在此基础上引入倒残差结构与线性瓶颈结构，进一步提升了特征表达能力。MobileNetV3 结合神经网络架构搜索（NAS）与注意力机制，在准确率与推理效率之间取得了更优平衡。

与此同时，多尺度特征提取与动态感受野机制逐渐受到研究者关注。不同表情在面部区域中的特征分布存在明显差异，例如“高兴”表情主要体现在嘴角区域，而“愤怒”表情则更多依赖眉毛与眼部区域。因此，通过动态调整卷积感受野大小，使模型能够自适应关注不同尺度的特征区域，有助于提升模型对于复杂表情的识别能力。

=== 边缘设备与实时识别需求

随着智能终端设备的快速普及，人脸表情识别技术逐渐应用于移动设备、人机交互系统以及实时监控场景中。在这些实际应用环境中，系统不仅需要较高识别准确率，同时还需要满足实时推理、低功耗以及低延迟等要求。

例如，在移动终端设备中，由于硬件资源有限，大型深度学习模型往往难以直接运行；在智能监控与在线交互场景中，系统需要在短时间内完成图像采集、特征提取以及表情分类等任务，因此模型推理速度直接影响用户体验。此外，在边缘计算环境中，本地化推理能够减少数据传输延迟，提高系统实时性，并增强用户隐私保护能力。

因此，仅仅追求模型高准确率已经无法满足实际应用需求。如何设计一种兼顾轻量化、高准确率以及实时性能的人脸表情识别模型，成为当前研究中的关键问题。

=== 本课题研究意义

针对当前表情识别模型存在参数量大、计算复杂度高以及难以部署于边缘设备等问题，本文围绕轻量化表情识别模型展开研究，提出了一种基于 Dynamic-MobileNetV3Small 的轻量化表情识别方法。

首先，针对 FerPlus 数据集中存在图像分辨率较低、光照变化明显等问题，本文设计了结合超分辨率重建与 CLAHE 光照增强的数据预处理流程，通过提升图像质量增强模型特征提取能力。

其次，本文以 MobileNetV3Small 为基础网络，引入动态感受野模块，通过并行不同尺度的 Depthwise Convolution 提取多尺度表情特征，并利用自适应权重融合机制动态调整不同尺度特征的重要性，使模型能够根据不同表情自适应关注关键区域，从而提升识别性能。

最后，本文在 FerPlus 与 RAF-DB 数据集上进行了大量实验验证。实验结果表明，所提出的模型在保持较低计算复杂度的同时取得了较好的识别准确率，在轻量化与性能之间实现了较好平衡，为移动端与边缘设备上的表情识别研究提供了一定参考价值。

== 国内外研究现状

=== 传统表情识别方法研究现状

传统人脸表情识别方法主要依赖人工设计特征进行图像表示与分类识别。早期研究通常采用几何特征与纹理特征相结合的方法，通过提取人脸关键点位置变化以及局部纹理信息完成表情分类。

在纹理特征方面，局部二值模式（LBP）由于具有较强的灰度不变性，被广泛应用于表情识别任务。Gabor 小波特征能够有效提取不同方向与尺度的纹理信息，在复杂表情特征建模中具有较好效果。方向梯度直方图（HOG）则通过统计图像局部梯度方向信息实现特征描述。

在分类方法方面，传统研究通常采用支持向量机（SVM）、K 近邻（KNN）以及 Adaboost 等机器学习算法完成表情分类任务。虽然传统方法在小规模数据集上具有一定效果，但由于其依赖人工经验设计特征，因此泛化能力有限，难以适应复杂环境下的人脸表情识别任务。

=== 基于深度学习的表情识别研究现状

随着深度学习技术的发展，卷积神经网络逐渐成为表情识别领域的主流方法。CNN 能够自动学习图像深层语义特征，相比传统人工特征具有更强的表达能力。

VGGNet 通过增加网络深度提升特征提取能力，在表情识别任务中取得了较好效果。ResNet 引入残差结构，有效解决了深层网络训练中的梯度消失问题，提高了模型训练稳定性。近年来，注意力机制与 Transformer 结构逐渐应用于表情识别领域，例如 CBAM 能够增强模型对关键通道与空间区域的关注能力，而 Vision Transformer（ViT）则通过全局特征建模提升复杂表情识别能力。

此外，多尺度特征融合逐渐成为研究热点。由于不同表情在面部区域中的特征分布差异明显，研究者开始通过不同尺度卷积核提取局部与全局特征，从而增强模型对复杂表情的识别能力。

=== 轻量化神经网络研究现状

随着移动端视觉应用需求不断增加，轻量化神经网络研究逐渐受到广泛关注。MobileNet 系列网络通过深度可分离卷积显著降低模型计算量，在移动设备中具有较高应用价值。ShuffleNet 通过通道重排机制减少计算复杂度，提高网络运行效率。EfficientNet 则采用复合缩放策略，在模型深度、宽度与输入分辨率之间实现平衡优化。

近年来，研究者开始将轻量化网络应用于表情识别任务，通过减少参数量与计算量提升模型实时性能。然而，由于轻量化模型特征提取能力相对有限，在复杂场景下容易出现识别精度下降问题。因此，如何进一步增强轻量化模型的特征表达能力，仍是当前研究的重要方向。

=== 注意力机制与动态感受野研究现状

注意力机制能够通过增强模型对关键区域的关注能力，提高特征提取效果。目前常见注意力机制包括 SENet、CBAM 与 ECA 等。其中，CBAM 同时结合通道注意力与空间注意力，能够有效提升模型对关键面部区域的特征感知能力。

与此同时，动态感受野机制逐渐成为研究热点。传统卷积网络通常采用固定大小卷积核进行特征提取，但不同表情所对应的关键区域尺度存在差异，因此固定感受野难以充分适应复杂表情特征。

近年来，研究者开始采用多尺度卷积结构与动态卷积机制增强网络特征表达能力。例如，通过并行不同尺度卷积核提取多尺度特征，并利用注意力机制动态融合不同尺度信息，从而提升模型对复杂目标的感知能力。这类方法为轻量化表情识别模型设计提供了新的研究思路。

=== 当前研究存在的问题

虽然当前人脸表情识别技术已经取得较大进展，但仍然存在以下问题：

(1) 大多数高精度模型参数量较大，计算复杂度较高，难以部署于移动端与边缘设备；

(2) 轻量化模型虽然能够降低计算量，但容易导致特征表达能力不足，从而影响识别准确率；

(3) 不同表情对应的关键区域存在明显差异，传统固定感受野卷积难以有效适应复杂表情特征；

(4) 数据集普遍存在光照变化、遮挡以及低分辨率等问题，影响模型鲁棒性。

因此，研究一种兼顾轻量化、高准确率以及多尺度特征建模能力的表情识别模型具有重要研究意义。

== 本文研究内容

=== 研究目标

本文旨在设计一种适用于移动端与边缘设备部署的轻量化表情识别模型，在降低模型参数量与计算复杂度的同时，提高模型对复杂表情特征的识别能力。

具体研究目标包括：

(1) 构建适用于表情识别任务的数据预处理流程，提高输入图像质量与模型鲁棒性；

(2) 研究轻量化卷积神经网络结构，降低模型参数量与 FLOPs；

(3) 引入动态感受野机制，增强模型对多尺度表情特征的提取能力；

(4) 在保证模型轻量化的基础上，提高表情识别准确率与实时性能。

=== 研究思路与技术路线

本文首先对 FerPlus 与 RAF-DB 数据集进行预处理，通过超分辨率重建提升图像分辨率，并采用 CLAHE 光照增强改善图像质量，同时结合随机翻转、随机裁剪等数据增强策略提升模型泛化能力。

随后，本文以 MobileNetV3Small 为基础网络，对其网络结构进行改进。在深度可分离卷积模块中引入 Dynamic Receptive Field Block，通过并行不同尺度的 Depthwise Convolution 提取多尺度表情特征，并利用自适应权重融合机制动态调整不同尺度特征的重要性。

最后，在 Ubuntu 22.04 与 PyTorch 深度学习框架环境下完成模型训练与实验验证，并与 ResNet18、MobileNetV1、MobileNetV2 等主流模型进行对比分析，验证所提出模型的有效性。

=== 本文主要工作

本文主要完成了以下几个方面的工作：

(1) 对 FerPlus 与 RAF-DB 数据集进行了分析与预处理，设计了结合超分辨率重建与 CLAHE 光照增强的数据增强流程；

(2) 对 ResNet18、ResNet18+CBAM、ResNet18+ViT、MobileNetV1、MobileNetV2 以及 MobileNetV3Small 等模型进行了实验对比分析；

(3) 提出了一种 Dynamic-MobileNetV3Small 模型，在 MobileNetV3Small 基础上引入动态感受野模块，实现多尺度特征提取；

(4) 通过大量实验验证了所提出模型在轻量化与识别性能之间具有较好平衡能力。

=== 本文创新点

本文的主要创新点如下：

(1) 提出了一种基于 MobileNetV3Small 的动态感受野结构，通过并行 3×3 与 5×5 Depthwise Convolution 提取多尺度表情特征；

(2) 引入自适应权重融合机制，使模型能够根据不同表情动态调整不同感受野的重要性；

(3) 结合超分辨率重建与 CLAHE 光照增强，提高低分辨率表情图像的特征质量；

(4) 在较低计算复杂度条件下实现较高识别准确率，在轻量化与性能之间取得较好平衡。

== 论文结构安排

本文共分为六章，各章节内容安排如下：

第一章为绪论，主要介绍人脸表情识别的研究背景与意义，综述国内外研究现状，并阐述本文的研究内容、技术路线以及创新点。

第二章为相关理论与关键技术，主要介绍卷积神经网络基础理论、轻量化网络结构、MobileNet 系列网络以及注意力机制与动态感受野相关理论。

第三章为数据集与数据预处理，主要介绍 FerPlus 与 RAF-DB 数据集，并详细说明超分辨率重建、CLAHE 光照增强以及数据增强等预处理方法。

第四章为轻量化表情识别模型设计，重点介绍 Dynamic-MobileNetV3Small 模型结构设计、动态感受野模块以及特征融合机制。

第五章为实验设计与结果分析，介绍实验环境、训练参数设置以及模型对比实验与消融实验，并对实验结果进行分析。

第六章为总结与展望，总结本文研究工作与实验成果，并对未来轻量化表情识别研究方向进行展望。


= 相关理论与关键技术


== 卷积神经网络基础

卷积神经网络（Convolutional Neural Network，CNN）是一类广泛应用于计算机视觉领域的深度学习模型，具有较强的图像特征提取能力。相比传统神经网络，CNN 能够通过局部连接与参数共享自动学习图像中的边缘、纹理以及高级语义特征，因此在人脸识别、目标检测以及表情识别等任务中得到了广泛应用。

如 @img:img-conv 所示，卷积神经网络通常由卷积层、池化层、全连接层以及输出层组成。网络前部主要负责图像特征提取，后部则完成特征分类任务。

#imagex(
  image("figures/conv.png", width: 100%),
  caption: [典型卷积神经网络结构示意图],
  label-name: "img-conv",
  placement: none, // 默认 none, 即图片会强制显示在当前位置; 还可以设置为 auto, top, bottom, 分别表示自动、顶部、底部 (推荐使用 auto)
)

=== 卷积层

卷积层是卷积神经网络中的核心结构，其主要作用是对输入图像进行特征提取。卷积操作通过卷积核在图像上滑动，对局部区域进行加权计算，从而提取图像中的边缘、纹理以及形状等信息。

随着网络层数不断增加，卷积层能够逐渐学习更加抽象的高级语义特征。在人脸表情识别任务中，卷积层能够有效提取眉毛、眼睛、嘴角等关键区域特征，为后续表情分类提供基础。

为了降低模型计算复杂度，本文采用 MobileNetV3Small 中的深度可分离卷积结构，通过将标准卷积分解为逐通道卷积与逐点卷积，在保证特征提取能力的同时减少模型参数量与计算量。

=== 池化层

池化层（Pooling Layer）主要用于对特征图进行下采样，从而减少特征图尺寸与模型计算量，同时提高模型对局部平移变化的鲁棒性。

常见池化方式包括最大池化（Max Pooling）与平均池化（Average Pooling）。其中，最大池化能够保留更加显著的局部特征，因此在卷积神经网络中应用更加广泛。

在轻量化网络中，通常使用全局平均池化（Global Average Pooling）替代传统全连接层，从而进一步减少模型参数量并降低过拟合风险。

=== 激活函数

激活函数用于为神经网络引入非线性表达能力，使模型能够学习复杂特征之间的映射关系。常见激活函数包括 Sigmoid、Tanh 与 ReLU 等。

ReLU（Rectified Linear Unit）由于计算简单、训练速度快以及能够缓解梯度消失问题，被广泛应用于深度卷积神经网络中。

MobileNetV3Small 中采用了 h-swish 激活函数。相比传统 ReLU 与 Swish 函数，h-swish 在保持较好性能的同时具有更低计算开销，更适用于移动端与轻量化网络。

=== Batch Normalization

Batch Normalization（BN）是一种常用的特征归一化方法，其主要作用是在网络训练过程中对输入特征进行标准化处理，从而缓解内部协变量偏移问题。

BN 能够加快模型收敛速度，提高训练稳定性，并在一定程度上减轻过拟合现象。因此，在现代卷积神经网络中通常会在卷积层后加入 Batch Normalization 层。

=== 损失函数与优化器

损失函数用于衡量模型预测结果与真实标签之间的差异，是模型训练的重要组成部分。在表情识别任务中，通常采用交叉熵损失函数（Cross Entropy Loss）完成多分类训练。

优化器用于根据损失函数更新网络参数。常见优化器包括 SGD、Momentum 与 Adam 等。其中，Adam 优化器结合了动量优化与自适应学习率机制，具有收敛速度快、训练稳定等优点，因此在深度学习任务中应用广泛。

本文实验采用交叉熵损失函数作为分类损失，并使用 Adam 优化器完成模型训练，以提高模型训练效率与表情识别性能。

== 深度学习表情识别理论

人脸表情识别（Facial Expression Recognition，FER）是计算机视觉与模式识别领域的重要研究方向，其目标是通过分析人脸图像中的表情特征，自动识别人物情绪状态。随着深度学习技术的发展，基于卷积神经网络的人脸表情识别方法逐渐成为主流方案，相比传统人工特征方法具有更强的特征学习能力与更高的识别准确率。

深度学习表情识别通常包括人脸检测、图像预处理、特征提取以及表情分类等步骤。通过多层神经网络结构，模型能够自动学习不同表情对应的深层语义特征，从而实现复杂场景下的人脸表情识别任务。

=== 人脸表情识别流程

典型的人脸表情识别系统主要包括图像采集、人脸检测、图像预处理、特征提取以及表情分类五个阶段。

首先，系统通过摄像头或公开数据集获取人脸图像。随后，通过人脸检测算法定位人脸区域，并对图像进行裁剪与对齐，以减少背景干扰对模型识别结果的影响。

在图像预处理阶段，通常需要对输入图像进行尺寸统一、归一化以及光照增强等操作，以提升模型鲁棒性。本文采用超分辨率重建与 CLAHE 光照增强方法，提高低分辨率表情图像质量。

随后，深度卷积神经网络对输入图像进行特征提取。网络前层主要提取边缘、纹理等低层特征，而深层网络则能够学习更加抽象的表情语义信息，例如眉毛变化、眼部形态以及嘴角运动等关键区域特征。

最后，通过 Softmax 分类器输出不同表情类别的概率值，并将概率最大的类别作为最终识别结果。常见表情类别包括高兴、愤怒、悲伤、惊讶、中性等。

#imagex(
  image("figures/fer.png", width: 100%),
  caption: [人脸表情识别基本流程图],
  label-name: "img-fer",
  placement: none, // 默认 none, 即图片会强制显示在当前位置; 还可以设置为 auto, top, bottom, 分别表示自动、顶部、底部 (推荐使用 auto)
)

=== 表情特征提取方法

表情特征提取是人脸表情识别中的关键步骤，其主要目标是从人脸图像中提取能够反映情绪变化的重要特征信息。

传统表情识别方法通常采用人工设计特征，例如局部二值模式（LBP）、方向梯度直方图（HOG）以及 Gabor 特征等。这类方法能够提取局部纹理信息，但由于其特征表达能力有限，在复杂环境中的识别效果较差。

随着深度学习技术的发展，卷积神经网络逐渐成为主流特征提取方法。CNN 能够通过多层卷积结构自动学习图像深层语义特征，相比传统方法具有更强的表达能力。

在表情识别任务中，不同面部区域对表情识别的重要程度不同。例如，“高兴”表情通常主要体现在嘴角区域，而“愤怒”表情则更多依赖眉毛与眼部特征。因此，近年来研究者开始引入注意力机制与多尺度特征提取方法，使模型能够更加关注关键区域信息。

本文基于 MobileNetV3Small 网络，引入动态感受野模块，通过并行不同尺度卷积核提取多尺度表情特征，并利用自适应权重融合机制动态调整不同感受野的重要性，从而提升模型对复杂表情特征的提取能力。

=== 分类与识别原理

在人脸表情识别任务中，深度神经网络通过前向传播不断提取图像特征，并最终完成表情分类。

卷积神经网络首先通过卷积层提取局部特征，随后利用池化层降低特征图尺寸，并通过多层网络逐渐学习更加抽象的高级语义特征。在网络最后阶段，通常通过全连接层与 Softmax 分类器输出各类别概率。

Softmax 函数能够将网络输出映射为概率分布，其输出结果表示输入图像属于各个表情类别的概率大小。模型训练过程中，通过交叉熵损失函数计算预测结果与真实标签之间的误差，并利用反向传播算法不断更新网络参数，从而提高模型识别能力。

为了提高模型泛化能力，通常还需要结合数据增强、Batch Normalization 以及 Dropout 等方法减少过拟合现象。此外，在轻量化网络中，需要在模型复杂度与识别准确率之间进行平衡优化，以满足移动端与边缘设备中的实时识别需求。

本文提出的 Dynamic-MobileNetV3Small 模型在保持较低计算复杂度的同时，通过动态感受野机制增强多尺度特征建模能力，从而提高轻量化表情识别模型的整体性能。

== 轻量化神经网络理论

随着深度学习模型规模不断增加，传统卷积神经网络在获得较高识别精度的同时，也带来了参数量大、计算复杂度高以及推理速度慢等问题。在移动端与边缘设备中，硬件资源通常较为有限，因此需要通过轻量化方法降低模型复杂度，提高模型实时性能。

轻量化神经网络的核心目标是在尽可能减少模型参数量与计算量的同时，保持较高的识别准确率。目前常见轻量化方法包括深度可分离卷积、通道压缩、模型剪枝以及知识蒸馏等。其中，MobileNet 系列网络由于具有较好的轻量化性能，被广泛应用于移动端视觉任务中。

=== 深度可分离卷积

深度可分离卷积（Depthwise Separable Convolution）是轻量化网络中的核心结构，其主要思想是将传统标准卷积分解为逐通道卷积（Depthwise Convolution）与逐点卷积（Pointwise Convolution）两个步骤，从而降低模型计算复杂度。

传统卷积在卷积过程中会同时完成空间特征提取与通道特征融合。设输入特征图尺寸为：
$D_F times D_F$

输入和输出通道数分别为：
$M$, $N$


卷积核尺寸为：
$D_K times D_K$

则标准卷积计算量为：
$D_K^2 times M times N times D_F^2$

深度可分离卷积首先对每个输入通道分别进行卷积操作，然后利用 $1 times 1$ 卷积完成通道融合，其计算量为：
$D_K^2 times M times D_F^2 + M times N times D_F^2$

因此，深度可分离卷积能够显著减少计算量。当卷积核较大且输出通道数较多时，计算复杂度降低更加明显。

MobileNetV1 首次大规模采用深度可分离卷积结构，在保持较好识别性能的同时显著降低了模型参数量与 FLOPs，因此被广泛应用于轻量化视觉任务中。

#imagex(
  image("figures/depth-conv.png", width: 80%),
  caption: [深度可分离卷积示意图],
  label-name: "img-depth-conv",
  placement: none, // 默认 none, 即图片会强制显示在当前位置; 还可以设置为 auto, top, bottom, 分别表示自动、顶部、底部 (推荐使用 auto)
)
=== 通道压缩机制

通道压缩机制主要用于减少特征图通道数量，从而降低模型参数量与计算复杂度。在轻量化网络中，通常通过瓶颈结构（Bottleneck）实现通道压缩与特征重建。

MobileNetV2 提出的倒残差结构（Inverted Residual）首先利用 $1 times 1$ 卷积对特征通道进行扩展，随后采用深度可分离卷积进行特征提取，最后再通过 $1 times 1$ 卷积压缩通道数量。

这种结构相比传统残差结构具有更低的参数量，同时能够保留较强特征表达能力。此外，部分轻量化网络还会结合 SE 注意力机制，通过学习不同通道的重要性进一步提升特征利用效率。

在本文提出的 Dynamic-MobileNetV3Small 模型中，同样采用了轻量化通道压缩结构，以减少模型整体计算复杂度并提高推理效率。

=== 模型复杂度评价指标

在轻量化神经网络研究中，通常采用参数量（Parameters）、计算量（FLOPs）以及模型大小等指标评价模型复杂度。

参数量用于衡量模型规模大小，参数量越小，模型存储需求越低，更适合移动端部署。

FLOPs（Floating Point Operations）用于衡量模型计算复杂度，其值越低，模型推理速度通常越快。

对于标准卷积，其 FLOPs 计算公式为：

$2 times D_K^2 times M times N times D_F^2$

其中：

-- $D_K$ 表示卷积核尺寸

-- $M$ 表示输入通道数

-- $N$ 表示输出通道数

-- $D_F$ 表示特征图尺寸

此外，模型推理速度与实时帧率（FPS）也是衡量轻量化模型性能的重要指标。在移动端与边缘设备中，需要综合考虑识别准确率、参数量以及推理效率之间的平衡关系。

本文提出的 Dynamic-MobileNetV3Small 模型在仅约 0.05 GFLOPs 的计算量条件下实现了较高识别准确率，验证了所提出方法在轻量化表情识别任务中的有效性。

== MobileNet 系列网络

MobileNet 是 Google 提出的一系列轻量化卷积神经网络，主要面向移动端与嵌入式设备设计。相比传统卷积神经网络，MobileNet 系列在保持较高识别性能的同时，大幅降低了模型参数量与计算复杂度，因此被广泛应用于目标检测、人脸识别以及表情识别等实时视觉任务中。

MobileNet 系列网络主要包括 MobileNetV1、MobileNetV2 与 MobileNetV3 等版本，各版本在网络结构与轻量化方法上不断优化，提高了模型效率与特征表达能力。

=== MobileNetV1 网络结构

MobileNetV1 是最早提出的轻量化 MobileNet 网络，其核心思想是采用深度可分离卷积（Depthwise Separable Convolution）替代传统标准卷积，从而显著降低模型计算量。

传统卷积会同时完成空间特征提取与通道融合，而 MobileNetV1 将其分解为两个步骤：

(1) Depthwise Convolution

对每个输入通道分别进行卷积操作，用于提取空间特征。

(2) Pointwise Convolution

采用 $1 times 1$ 卷积完成不同通道之间的信息融合。

相比标准卷积，深度可分离卷积能够大幅减少模型参数量与 FLOPs，因此 MobileNetV1 在移动端设备中具有较高运行效率。

此外，MobileNetV1 还引入宽度缩放因子（Width Multiplier）与分辨率缩放因子（Resolution Multiplier），能够进一步调整模型复杂度，以适应不同硬件平台需求。

=== MobileNetV2 倒残差结构

虽然 MobileNetV1 显著降低了模型复杂度，但由于过度压缩特征信息，容易导致特征表达能力下降。为解决该问题，MobileNetV2 提出了倒残差结构（Inverted Residual）与线性瓶颈结构（Linear Bottleneck）。

传统残差结构通常先压缩通道后提取特征，而 MobileNetV2 采用相反方式，首先利用 $1 times 1$ 卷积扩展通道数量，然后通过深度可分离卷积提取特征，最后再利用 $1 times 1$ 卷积压缩通道数。

这种结构能够在低计算复杂度条件下保留更多特征信息，提高模型表达能力。同时，MobileNetV2 在输出层采用线性激活函数，避免了 ReLU 在低维空间中的信息损失问题。

倒残差结构不仅提高了模型性能，同时也增强了网络训练稳定性，因此成为后续轻量化网络的重要基础结构。

#imagex(
  image("figures/bottlenect_res.png", width: 80%),
  caption: [倒残差结构示意图],
  label-name: "img-bottlenect_res",
  placement: none, 
)

=== MobileNetV3Small 网络结构

MobileNetV3 是在 MobileNetV2 基础上进一步优化得到的轻量化网络，其结合了神经网络架构搜索（NAS）与注意力机制，在模型准确率与推理效率之间取得了更优平衡。

MobileNetV3 分为 Large 与 Small 两种结构，其中 MobileNetV3Small 更适用于移动端与边缘设备中的实时任务。

MobileNetV3Small 在网络结构中引入了 SE（Squeeze-and-Excitation）注意力机制，通过学习不同通道的重要性增强关键特征表达能力。同时，网络采用更加高效的 h-swish 激活函数替代传统 ReLU，提高模型非线性表达能力。

相比 MobileNetV2，MobileNetV3Small 在保持较低参数量的同时进一步提高了模型识别性能，因此本文选择其作为基础 Backbone 网络进行改进。

#imagex(
  image("figures/v3_block.png", width: 80%),
  caption: [MobileNetV3 Block示意图],
  label-name: "img-v3_block",
  placement: none, 
)

在本文提出的 Dynamic-MobileNetV3Small 模型中，基于 MobileNetV3Small 引入动态感受野模块，通过并行不同尺度卷积核增强模型多尺度特征提取能力，从而提高表情识别性能。

== 注意力机制与动态感受野

随着深度学习技术的发展，研究者逐渐发现传统卷积神经网络在特征提取过程中对所有区域采用相同处理方式，难以有效突出关键特征区域。因此，注意力机制（Attention Mechanism）被广泛引入计算机视觉任务中，用于增强模型对重要特征区域的关注能力。

在人脸表情识别任务中，不同表情通常对应不同关键区域。例如，“高兴”表情主要体现在嘴角区域，而“愤怒”表情则更加依赖眉毛与眼部特征。因此，通过注意力机制与动态感受野方法增强模型对关键区域与多尺度特征的提取能力，有助于提高表情识别性能。

=== CBAM 注意力机制

CBAM（Convolutional Block Attention Module）是一种轻量级注意力机制模块，其主要作用是增强模型对重要特征区域的关注能力。CBAM 主要包括通道注意力（Channel Attention）与空间注意力（Spatial Attention）两个部分。

通道注意力主要用于学习不同通道的重要程度。通过对输入特征图进行全局平均池化与最大池化，模型能够获得全局通道信息，并利用共享多层感知机生成通道权重，从而增强重要特征通道。

空间注意力则用于学习图像空间位置的重要程度。该模块通过对特征图进行通道压缩，并利用卷积操作生成空间权重图，使模型更加关注关键区域特征。

CBAM 结构简单、计算开销较低，能够有效提升卷积神经网络特征表达能力，因此被广泛应用于轻量化视觉任务中。本文在对比实验中引入 ResNet18+CBAM 模型，用于分析注意力机制对表情识别性能的影响。

=== Vision Transformer 基础

Transformer 最初应用于自然语言处理领域，随后逐渐被引入计算机视觉任务中。Vision Transformer（ViT）通过自注意力机制实现图像全局特征建模，相比传统卷积神经网络具有更强的全局信息提取能力。

ViT 首先将输入图像划分为多个固定大小的 Patch，并将每个 Patch 映射为特征向量。随后，通过位置编码保留空间位置信息，并利用多头自注意力机制学习不同区域之间的特征关系。

相比传统卷积操作，ViT 能够更有效地捕获远距离特征依赖关系，因此在复杂视觉任务中表现出较强性能。然而，Transformer 通常需要较大数据量与较高计算资源支持，因此在移动端任务中的应用仍受到一定限制。

本文在实验部分对 ResNet18+ViT 模型进行了对比分析，用于研究 Transformer 结构在人脸表情识别任务中的表现。

=== 多尺度特征提取

在人脸表情识别任务中，不同表情特征通常具有不同空间尺度。例如，嘴角变化属于局部细粒度特征，而整体面部肌肉变化则属于较大尺度特征。因此，仅使用单一尺度卷积核难以充分提取复杂表情信息。

多尺度特征提取方法通常采用不同大小卷积核并行提取特征。例如：

+ 小卷积核更加关注局部纹理与细节信息；
+ 大卷积核能够获取更加广泛的上下文信息。

通过融合不同尺度特征，模型能够同时学习局部细节与全局语义信息，从而提高复杂表情识别能力。

近年来，多尺度卷积结构被广泛应用于轻量化网络中。例如 Inception 模块通过并行不同尺度卷积核实现多尺度特征融合，提高模型特征表达能力。

本文提出的 Dynamic-MobileNetV3Small 模型同样采用多尺度特征提取思想，通过并行 $3 times 3$ 与 $5 times 5$ Depthwise Convolution 提取不同尺度表情特征，从而增强模型对于复杂表情区域的感知能力。

=== 动态感受野机制

感受野（Receptive Field）表示卷积神经网络中某一神经元所对应的输入区域大小。传统卷积网络通常采用固定大小卷积核，因此其感受野范围固定，难以适应不同尺度目标特征。

在人脸表情识别任务中，不同表情对应的关键区域大小存在明显差异。例如，“惊讶”表情通常涉及较大范围面部变化，而“轻微悲伤”可能仅表现为局部嘴角变化。因此，固定感受野难以同时兼顾不同尺度特征提取需求。

动态感受野机制通过自适应调整不同卷积尺度的重要性，使模型能够根据输入特征动态选择更加合适的感受范围，从而增强模型特征表达能力。

本文提出的 Dynamic Receptive Field Block 采用并行多尺度 Depthwise Convolution 结构，通过同时提取不同尺度特征，并利用自适应权重融合机制动态调整不同感受野的重要程度，使模型能够更加有效地关注不同表情对应的关键区域。

相比传统固定卷积结构，动态感受野机制能够在保持较低计算复杂度的同时，提高模型对复杂表情特征的建模能力，从而提升整体识别性能。

= 数据集与数据预处理

== 实验数据集介绍

为了验证本文提出模型的有效性，实验选取了 FerPlus 与 RAF-DB 两个主流公开人脸表情识别数据集进行训练与测试。这两个数据集包含多种复杂场景下的人脸表情图像，具有较高研究价值与代表性。

=== FerPlus 数据集

FerPlus 是在 FER2013 数据集基础上重新标注得到的人脸表情识别数据集。相比原始 FER2013 数据集，FerPlus 采用多标签投票方式重新标注表情类别，从而提高了标签准确性与数据质量。

FerPlus 数据集中的图像主要来源于互联网环境，包含不同光照、遮挡、姿态变化以及复杂背景条件，因此更加贴近真实场景。数据集图像均为灰度图像，原始分辨率为：$48 times 48$

#imagex(
  image("figures/ferplus_showcase.png", width: 80%),
  caption: [FerPlus数据集],
  label-name: "img-ferplus_showcase",
)

FerPlus 共包含约 35,000 张人脸图像，主要包括以下八种基本表情类别：

-- Angry（愤怒）

-- Disgust（厌恶）

-- Fear（恐惧）

-- Happy（高兴）

-- Sad（悲伤）

-- Surprise（惊讶）

-- Neutral（中性）

-- Contempt（轻蔑）

由于原始图像分辨率较低，细节信息容易丢失，因此本文在数据预处理阶段采用超分辨率重建方法，将图像统一提升至：$224 times 224$，同时结合 CLAHE 光照增强，提高图像质量与模型鲁棒性。

=== RAF-DB 数据集

RAF-DB（Real-world Affective Faces Database）是一个面向真实场景的人脸表情识别数据集，由大量互联网自然场景图像组成，能够较好反映复杂环境下的人脸表情变化情况。

相比 FerPlus，RAF-DB 中的人脸图像具有更加丰富的姿态变化、光照变化以及遮挡情况，因此对模型泛化能力要求更高。

#imagex(
  image("figures/rafdb_showcase.png", width: 80%),
  caption: [RAF-DB数据集],
  label-name: "img-rafdb_showcase",
)

RAF-DB 数据集主要包括七种基本表情类别：

-- Surprise（惊讶）

-- Fear（恐惧）

-- Disgust（厌恶）

-- Happy（高兴）

-- Sad（悲伤）

-- Angry（愤怒）

-- Neutral（中性）

数据集共包含约 30,000 张人脸图像，其中基本表情数据约 15,000 张，广泛应用于深度学习表情识别研究任务。

由于 RAF-DB 数据集更加接近真实场景，因此本文将其作为重要测试数据集，用于验证模型在复杂环境下的表情识别能力。

=== 数据集类别分布

在人脸表情识别任务中，不同表情类别之间通常存在数据分布不均衡问题。例如，“Happy” 与 “Neutral” 类别样本数量通常较多，而 “Disgust” 与 “Contempt” 类别样本相对较少。

类别不平衡容易导致模型训练过程中偏向样本数量较多的类别，从而影响整体识别性能。因此，在模型训练阶段需要通过数据增强与类别权重等方法减轻类别不平衡问题。

本文在训练过程中采用随机翻转、随机裁剪以及随机旋转等数据增强方法，提高模型泛化能力。同时，在损失函数中引入类别权重，增强模型对少样本类别的学习能力。

#{
  // 读取文件，分隔符可以为分号
  let result = csv("data/fer-class-stats.csv", delimiter: ",")

  // 获取列数
  let m = result.at(0).len()

  // 获取表头
  let head = result.at(0)

  // 获取数据部分
  let data = result.slice(1)

  tablex(
    ..data.flatten(), // 将数据展平
    header: head, // 显示表头
    columns: m, // 设置列数
    caption: [Fer-plus各类别统计],
    label-name: "class-stats",
  )
}

== 数据预处理流程

为提升模型对复杂表情特征的学习能力，并增强网络在不同光照、姿态及图像质量条件下的鲁棒性，本文在训练前对原始图像进行了统一的数据预处理操作。预处理流程主要包括图像尺寸统一、超分辨率重建、CLAHE 光照增强以及数据归一化等步骤。通过对输入图像进行标准化处理，可以有效减少冗余噪声与无关因素对模型训练的影响，提高模型的收敛速度与最终识别精度。

#imagex(
  image("figures/preprocessing_pipeline.png", width: 80%),
  caption: [预处理流程展示],
  label-name: "img-preprocessing_pipeline",
)

=== 图像尺寸统一

由于 FERPlus 与 RAF-DB 数据集中图像来源复杂，不同样本之间存在分辨率不一致的问题，直接输入网络会导致特征提取尺度不统一，从而影响模型训练效果。因此，本文首先对所有输入图像进行尺寸统一处理。

在预处理阶段，采用 OpenCV 中的 `resize()` 函数将图像统一缩放至 $224 times 224$ 的固定尺寸，以满足 MobileNetV3 网络输入要求。图像缩放过程中使用双三次插值（Bicubic Interpolation）方法进行重采样，该方法能够较好地保留图像边缘与纹理信息，减少缩放过程中产生的失真现象。

统一尺寸后的图像不仅能够提高批量训练效率，还可以保证网络在不同样本间学习到一致的空间特征表示。

=== 超分辨率重建

在人脸表情识别任务中，部分样本存在分辨率较低、细节模糊的问题，容易导致细微表情特征丢失，从而影响模型对局部肌肉变化的感知能力。为增强低分辨率图像中的细节信息，本文在预处理阶段引入超分辨率重建技术，对输入图像进行质量增强。

超分辨率重建通过学习低分辨率图像与高分辨率图像之间的映射关系，对图像纹理与边缘细节进行恢复，从而提高图像清晰度。经过超分辨率增强后，面部关键区域如嘴角、眼部及眉毛等细节特征更加明显，有助于提升模型对细粒度表情特征的提取能力。

此外，超分辨率重建还能够在一定程度上缓解数据集中由于拍摄设备差异导致的图像质量不一致问题，提高模型在复杂场景下的泛化性能。

=== CLAHE 光照增强

在实际场景中，人脸图像常受到环境光照变化的影响，容易出现亮度不均、阴影遮挡及局部对比度不足等问题，从而降低表情特征的可辨识性。为增强图像局部区域的细节信息，本文采用限制对比度自适应直方图均衡化（Contrast Limited Adaptive Histogram Equalization，CLAHE）方法对图像进行光照增强处理。

CLAHE 方法首先将图像划分为多个局部区域，并分别对各区域执行直方图均衡化操作，从而提高局部对比度。与传统直方图均衡化方法相比，CLAHE 在增强图像细节的同时，通过设置对比度限制阈值，有效避免了噪声过度放大的问题。

本文在实验中设置 CLAHE 的 `clipLimit` 参数为 3.0，局部网格大小为 $8 times 8$。经过 CLAHE 增强后，人脸区域的纹理细节更加清晰，能够有效提升模型在复杂光照环境下的表情识别能力。

=== 数据归一化

为加快神经网络训练过程中的梯度收敛速度，并提高模型训练稳定性，本文对输入图像进行了数据归一化处理。

由于原始图像像素值范围为 $[0,255]$，不同维度之间数值差异较大，直接输入网络容易导致梯度更新不稳定。因此，本文首先将图像像素值缩放至 $[0,1]$ 区间，其计算公式如下：

$
x' = x / 255
$

其中，$x$ 表示原始像素值，$x'$ 表示归一化后的像素值。

归一化操作能够有效减小不同特征之间的数值差异，使网络参数更新更加稳定，同时降低梯度爆炸或梯度消失问题出现的概率。此外，经过归一化处理后，模型训练过程中的损失函数收敛速度更快，有助于提升整体训练效率与模型性能。

== 数据增强策略

为提高模型对不同姿态、角度及空间变化的鲁棒性，降低模型过拟合风险，本文在训练阶段对输入图像采用了多种数据增强方法。数据增强能够通过对原始样本进行随机变换扩充训练数据分布，从而提升模型的泛化能力。

=== 随机翻转

在人脸表情识别任务中，表情通常具有一定的左右对称性，因此本文采用随机水平翻转（Random Horizontal Flip）方法对训练图像进行增强。该方法以一定概率对输入图像进行左右翻转，从而增加模型对不同朝向人脸的适应能力。

通过随机翻转操作，可以有效扩充训练样本数量，提高模型在不同视角条件下的表情识别性能，同时降低模型对固定人脸方向的依赖。

=== 随机裁剪

随机裁剪（Random Crop）是一种常见的数据增强方式，通过在原始图像中随机选取局部区域作为网络输入，使模型学习更加丰富的局部特征表示。

该方法能够增强模型对人脸位置偏移与局部区域变化的鲁棒性，同时减少模型对固定空间位置特征的过度依赖，从而提升模型在复杂场景中的泛化能力。

=== 随机旋转

由于实际场景中的人脸图像可能存在轻微倾斜与姿态变化，因此本文采用随机旋转（Random Rotation）方法对训练图像进行增强。在训练过程中，随机对图像施加一定角度范围内的旋转变换，本文设置旋转角度范围为 $ 10 degree$。

随机旋转能够模拟现实环境中的头部姿态变化，提高模型对不同拍摄角度与面部方向的适应能力，从而增强模型的鲁棒性与稳定性。

此外，在完成数据增强后，本文进一步将图像转换为张量形式，并结合数据归一化操作对输入数据进行标准化处理，以加快模型训练过程中的收敛速度并提升训练稳定性。

== 数据集划分

为了保证模型训练与实验评估的可靠性，本文按照数据集官方提供的划分方式对 FERPlus 与 RAF-DB 数据集进行训练集、验证集以及测试集划分。通过合理的数据集划分，可以有效避免数据泄露问题，并更加客观地评估模型的实际泛化能力。

=== 训练集划分

训练集主要用于模型参数学习与特征提取能力训练。在训练阶段，网络通过不断迭代学习输入图像中的表情特征，并利用反向传播算法更新模型参数。

本文采用数据集官方提供的训练集样本进行模型训练。其中，FERPlus 数据集包含大量带有表情标签的人脸图像，RAF-DB 数据集则覆盖了多种真实场景下的人脸表情样本。为了进一步提升模型泛化能力，本文在训练阶段结合随机翻转、随机旋转等数据增强策略对训练样本进行扩充。

=== 验证集划分

验证集主要用于模型训练过程中的性能监控与超参数调整。在每轮训练结束后，通过验证集评估当前模型的识别准确率与损失变化情况，从而判断模型是否出现过拟合现象。

本文采用 FERPlus 数据集中官方提供的验证集作为模型验证数据。在训练过程中，根据验证集准确率动态保存性能最优模型，并结合学习率调整策略优化模型训练效果。

验证集不参与模型参数更新，仅用于模型性能评估与训练过程控制，从而保证实验结果的客观性与可靠性。

=== 测试集划分

测试集用于模型最终性能评估，以验证模型在未知数据上的泛化能力。测试阶段仅使用训练完成后的最优模型进行推理，不再进行参数更新。

本文采用数据集官方划分的测试集对模型进行实验评估，并使用准确率（Accuracy）、F1-Score 等指标对模型性能进行综合分析。通过在测试集上的实验结果，可以客观反映模型在人脸表情识别任务中的实际应用效果。

此外，为保证实验结果的公平性与可复现性，训练集、验证集与测试集之间不存在重复样本，从而避免数据交叉带来的性能偏差问题。

= 轻量化表情识别模型设计

== 系统总体架构设计
=== 系统功能模块
=== 模型训练流程
=== 表情识别流程

== 基础对比模型设计
=== ResNet18 模型
=== ResNet18 + CBAM 模型
=== ResNet18 + ViT 模型
=== MobileNetV1 模型
=== MobileNetV2 模型
=== MobileNetV3Small 模型

== Dynamic-MobileNetV3Small 模型设计
=== 网络整体结构
=== Dynamic Receptive Field Block 设计
=== 并行 3×3 与 5×5 Depthwise Conv
=== 自适应权重融合机制
=== 特征融合流程

== 模型复杂度分析
=== 参数量分析
=== FLOPs 分析
=== 推理速度分析
=== 模型轻量化优势分析


= 实验设计与结果分析

== 实验环境配置
=== 硬件环境
=== 软件环境
=== PyTorch 深度学习框架

== 模型训练参数设置
=== Batch Size 设置
=== 学习率设置
=== 优化器选择
=== 损失函数设置

== 模型对比实验
=== 不同模型准确率对比
=== 参数量与 FLOPs 对比
=== F1-Score 对比
=== 推理效率对比

== 消融实验
=== CLAHE 光照增强实验
=== 超分辨率重建实验
=== Dynamic Receptive Field Block 消融实验
=== 不同卷积核组合实验

== 实验结果分析
=== Dynamic-MobileNetV3Small 性能分析
=== 多尺度特征提取效果分析
=== 轻量化与准确率平衡分析
=== 模型优势与不足


= 表情识别系统实现

== 系统需求分析
=== 功能需求
=== 性能需求

== 系统整体设计
=== 系统架构设计
=== 模块划分

== 模型部署与推理
=== 模型保存与加载
=== 推理流程设计
=== 实时识别实现

== 系统运行结果展示
=== 表情识别结果展示
=== 系统界面展示
=== 实际运行效果分析


= 总结与展望

== 本文工作总结
=== 数据预处理工作总结
=== 模型设计工作总结
=== 实验结果总结

== 本文创新点总结
=== 动态感受野模块创新
=== 轻量化结构优化
=== 多尺度特征融合创新

== 不足与未来展望
=== 当前模型存在的问题
=== 后续优化方向
=== 表情识别未来研究趋势


= 参考文献


= 附录

== 关键代码
== 实验配置文件
== 部分实验结果数据


= 致谢


// 111111111111111111111111111111111111

= 一级标题

== 引言

学位论文......

=== 三级标题

......

==== 四级标题

......

== 本文研究主要内容

本文......

== 本文研究意义

本文......

== 本章小结

本文......

= 格式要求


正文各章节应拟标题，每章结束后应另起一页。标题要简明扼要，不应使用标点符号。各章、节、条的层次，可以按照“1……、1.1……、1.1.1……”标识，条以下具体款项的层次依次按照“1.1.1.1”或“（1）”、“①”等标识。各学院根据实际情况，可自行规定层次格式，但学院之内建议格式统一，以清晰无误为准。

正文是毕业论文的主体和核心部分，不同学科专业和不同的选题可以有不同的写作方式。正文一般包括以下几个方面。

== 引言或背景
引言是论文正文的开端，引言应包括毕业论文选题的背景、目的和意义；对国内外研究现状和相关领域中已有的研究成果的简要评述；介绍本项研究工作研究设想、研究方法或实验设计、理论依据或实验基础；涉及范围和预期结果等。要求言简意赅，注意不要与摘要雷同或成为摘要的注解。

== 主体
论文主体是毕业论文的主要部分，必须言之成理，论据可靠，严格遵循本学科国际通行的学术规范。在写作上要注意结构合理、层次分明、重点突出，章节标题、公式图表符号必须规范统一。论文主体的内容根据不同学科有不同的特点，一般应包括以下几个方面：
+ 毕业设计（论文）总体方案或选题的论证；
+ 毕业设计（论文）各部分的设计实现，包括实验数据的获取、数据可行性及有效性的处理与分析、各部分的设计计算等；
+ 对研究内容及成果的客观阐述，包括理论依据、创新见解、创造性成果及其改进与实际应用价值等；
+ 论文主体的所有数据必须真实可靠，自然科学论文应推理正确、结论清晰；人文和社会学科的论文应把握论点正确、论证充分、论据可靠，恰当运用系统分析和比较研究的方法进行模型或方案设计，注重实证研究和案例分析，根据分析结果提出建议和改进措施等。

== 结论
结论是毕业论文的总结，是整篇论文的归宿。应精炼、准确、完整。着重阐述自己的创造性成果及其在本研究领域中的意义、作用，还可进一步提出需要讨论的问题和建议。

= 图表格式

== 图格式
=== 单张图片
#imagex(
  image("figures/energy-distribution.png", width: 70%),
  caption: [示例图片],
  label-name: "image1",
)

=== 多个子图
#imagex(
  subimagex(
    image("figures/energy-distribution.png", width: 70%),
    caption: "子图a",
    label-name: "sub1",
  ),
  subimagex(image("figures/energy-distribution.png", width: 70%)),
  subimagex(image("figures/energy-distribution.png", width: 70%)),
  subimagex(image("figures/energy-distribution.png", width: 70%)),
  columns: 2,
  caption: [示例子图],
  label-name: "image2",
  placement: none, // 默认 none, 即图片会强制显示在当前位置; 还可以设置为 auto, top, bottom, 分别表示自动、顶部、底部 (推荐使用 auto)
)

#pagebreak()

== 表格格式

表格可以在换页的时候自然断开并显示“续表xxxx”，如果需要令表显示在整页中，请将表中的`breakable`设置为`false`。

#tablex(
  ..for i in range(5) {
    ([250], [88], [5900], [1.65])
  },
  header: (
    [感应频率 #linebreak() (kHz)],
    [感应发生器功率 #linebreak() (%×80kW)],
    [工件移动速度 #linebreak() (mm/min)],
    [感应圈与零件间隙 #linebreak() (mm)],
  ),
  columns: (1fr, 1fr, 1fr, 1fr),
  caption: [示例表格],
  label-name: "table1",
  breakable: true,
)

== 公式格式

$ 1 / mu nabla^2 Alpha - j omega sigma Alpha - nabla(1 / mu) times (nabla times Alpha) + J_0 = 0 $<equation>

#h(-2em)其中$mu$是材料的磁导率，$sigma$是材料的电导率，$omega$是电磁波的角频率，$Alpha$是电磁场的矢量位，$J_0$是电流密度。使用```typst #h(-2em)```取消这一行前面的缩进。

#pagebreak()

== 算法格式
算法和表格一样也是换页的时候自然断开并显示“续算法xxxx”。
#[
  #import "@preview/lovelace:0.2.0": *
  #algox(
    label-name: "algorithm",
    caption: [欧几里得辗转相除],
    breakable: true,
    pseudocode(
      no-number,
      [#h(-1.25em) *input:* integers $a$ and $b$],
      no-number,
      [#h(-1.25em) *output:* greatest common divisor of $a$ and $b$],
      [*while* $a != b$ *do*],
      ind,
      [*if* $a > b$ *then*],
      ind,
      $a <- a - b$,
      ded,
      [*else*],
      ind,
      $b <- b - a$,
      ded,
      [*end*],
      ded,
      [*end*],
      [*return* $a$],
    ),
  )
]

也可以直接插入代码：
#algox(
  caption: [欧几里得辗转相除C++实现],
  [
    ```cpp
    #include <bits/stdc++.h>
    using namespace std;
    int gcd(int a, int b) {
      while (a != b) {
        if (a > b) a -= b;
        else b -= a;
      }
      return a;
    }
    ```
  ],
)

= 引用格式

== 常规引用

#tablex(
  header: (
    [引用对象],
    [效果],
    [原始代码],
  ),
  [表格],
  [我要引用@tbl:table1],
  [```typst 我要引用@tbl:table```],
  table.cell(
    rowspan: 2,
    align: horizon,
  )[图片],
  [我要引用@img:image1],
  [```typst 我要引用@img:image1```],
  [我要引用@img:image2:sub1],
  [```typst 我要引用@img:subfigures1:test```],
  [算法],
  [我要引用@algo:algorithm],
  [```typst 我要引用@algo:algorithm```],
  [公式],
  [我要引用@eqt:equation],
  [```typst 我要引用@eqt:equation```],
  columns: (1fr, 1fr, 1fr),
  caption: [常规引用示例表],
)

另一种函数引用方法: ```typst #ref(<img:image1>)```

== 章节引用<main_test>

我要引用@main_test：```typst 我要引用@main_test ```

我要引用#ref(<appendix1>)：```typst 我要引用#ref(<appendix1>)```

== 页面引用
请注意#ref(<jump>, form: "page") 的```typst #bib```函数，它会因为`citation.full`参数变化而发生变化。

#pagebreak()

== 文献引用

#tablex(
  header: (
    [引用对象],
    [效果],
    [原始代码],
  ),
  [句子末尾引用],
  [Typst很厉害@liu_survey_2024],
  [```typst Typst很厉害@liu_survey_2024```],

  [句子末尾引用],
  [Typst很厉害#citex(<test>)],
  [```typst Typst很厉害#citex(<test>)```],

  [句子内部引用],
  [文献#citex(<liu_survey_2024>, sup: false)说Typst很厉害],
  text(0.7em)[```typst 文献#citex(<liu_survey_2024>,sup:false) 说Typst很厉害```],

  table.hline(stroke: 0.2pt),

  [用别的格式的引用(自行查阅参数)],
  [#citex(<liu_survey_2024>, style: "future-science", form: "prose")\ 这些人说的],
  text(0.8em)[```typst #citex(<liu_survey_2024>,style: "future-science", form:"prose")
    \ 这些人说的```],

  alignment: left + horizon,
  columns: (1fr, 1.5fr, 2fr),
  caption: [文献引用示例表],
  label-name: "table2",
)

当`citation`中的`sup`为`true`的时候，所有的不标注`sup`的引用默认不为右上标；当`citation`中的`sup`为`true`的时候，所有的不标注`sup`的引用默认为右上标。

使用别的格式时`sup`失效。

= 高级格式

== 数据表格

无论是LaTex还是Word，将大量的数据制作成表格往往是一个非常复杂的过程。更何况这些实验数据日后可能还会变更，那么又要对表格的部分内容进行调整（比如加粗数据最大的那一项），这里给出一个制作数据表格的快捷方法，大致的流程是：
+ 将数据保存为CSV格式（Excel等均支持该格式）；
+ 使用Typst读取；
+ 排版并处理数据。
#ref(<tbl:data1>)是一个简单的例子：

#{
  // 读取文件，分隔符可以为分号
  let result = csv("data/heros.csv", delimiter: ",")

  // 获取列数
  let m = result.at(0).len()

  // 获取表头
  let head = result.at(0)

  // 获取数据部分
  let data = result.slice(1)

  tablex(
    ..data.flatten(), // 将数据展平
    header: head, // 显示表头
    columns: m, // 设置列数
    caption: [超级英雄能力表],
    label-name: "data1",
  )
}

#ref(<tbl:data2>)是一个更复杂的例子：

#let colors = (
  rgb(214, 38, 40, 255),
  rgb(43, 160, 43, 255),
  rgb(158, 216, 229, 255),
  rgb(114, 158, 206, 255),
  rgb(204, 204, 91, 255),
  rgb(255, 186, 119, 255),
  rgb(147, 102, 188, 255),
  rgb(30, 119, 181, 255),
  rgb(188, 188, 33, 255),
  rgb(255, 127, 12, 255),
  rgb(196, 175, 214, 255),
)

#{
  let results = csv("data/nyuv2.csv", delimiter: ",")
  let m = results.at(0).len()
  let head = results.at(0)

  // 将中间的标签旋转90度
  for y in range(m - 3) {
    head.at(y + 2) = rotate(
      90deg,
      stack(dir: ltr, box(fill: colors.at(y), inset: 4pt), head.at(y + 2)),
      reflow: true,
    )
  }
  let data = results.slice(1)

  // 将数据中的最大项找出并加粗
  for y in range(1, m) {
    // 去除非数据元素
    let col_num = data.map(row => row.at(y)).filter(it => it.contains(regex("\d")))

    // 找出最大值
    let max_val = col_num.map(float).reduce(calc.max)

    // 加粗最大值
    data = data.map(row => {
      let item = row.at(y)
      if item.contains(regex("\d")) and float(item) == max_val {
        row.at(y) = [#strong(item)]
      }
      row
    })
  }
  tablex(
    table.vline(x: 2, stroke: 0.2pt),
    table.vline(x: m - 1, stroke: 0.2pt),
    ..data.flatten(),
    header: head,
    columns: (15%, 7%, ..(auto,) * 11, 8%),
    caption: [主流模型在NYUv2数据集下的性能表现],
    label-name: "data2",
  )
}
#pagebreak()

== 流程图绘制

使用#link("https://typst.app/universe/package/fletcher", underline([Fletcher]))可以绘制流程图，点击横线处链接查看使用文档。

#imagex(
  image("figures/fletcher.png"),
  caption: [Fletcher示例],
)

#pagebreak()

== 复杂图形绘制

Fletcher是基于#link("https://typst.app/universe/package/cetz", underline([CeTZ]))的，CeTZ可以绘制更复杂的图形，点击横线处链接查看使用文档。

#imagex(
  image("figures/cetz.png"),
  caption: [CeTZ示例],
)

#pagebreak()

== LaTex公式
如果你不习惯Typst的公式，可以使用#link("https://typst.app/universe/package/mitex", underline([MiTex]))，点击横线处链接查看使用文档。

#import "@preview/mitex:0.2.6": *

行内公式如下：#mi("x") 或 #mi[y]。

块级公式如#ref(<eqt:equation1>)：
#mitex(`
  \newcommand{\f}[2]{#1f(#2)}
  \f\relax{x} = \int_{-\infty}^\infty
    \f\hat\xi\,e^{2 \pi i \xi x}
    \,d\xi
`)<equation1>

// 显示结论
#conclusion[
  结论是毕业论文的总结，是整篇论文的归宿。应精炼、准确、完整。着重阐述自己的创造性成果及其在本研究领域中的意义、作用，还可进一步提出需要讨论的问题和建议。
]

// 显示参考文献
#bib()

<jump>

// 设置附录文档格式
#show: appendix

= 附录格式
<appendix1>

论文附录依次用大写字母“附录A、附录B、附录C……”表示，附录内的分级序号可采用“附A1、附A1.1、附A1.1.1”等表示，图、表、公式均依此类推为“图A1、表A1、式（A1）”等。包含以下内容：

（1）代码、图表、标准、手册等数据；

（2）未发表过的一手文献；

（3）公式推导与证明、调查表等；

（4）辅助性教学工具或表格；

（5）其他需要展示或说明的内容

……

（标题黑体小二号，内容Times New Roman/宋体，小四号，行距20磅）

// 显示感谢
#acknowledgement(
  location: "上海大学",
  date: none, // 日期为空则默认为当天
)[
  表达真情实感即可。

  （致谢部分切勿照搬，本部分内容也在论文查重范围之内）

  （格式：宋体，Times New Roman小四号字，两边对齐，首行缩进2个字符，行距23磅，字符间距为“标准”）

]

// 显示封底
#under-cover()
