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
    fallback: true,
    songti: ("Noto Serif CJK SC", ), // 思源宋体，效果优于 SimSun
    heiti: ("Noto Sans CJK SC", ),   // 思源黑体，效果优于 SimHei
    kaiti: ("AR PL UKai CN", ),      // 文鼎PL中楷，Fedora中常见的开源楷体
    dengkuan: ("JetBrains Mono", ),  // 等宽字体，用于代码
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
  keywords: ("表情识别", "轻量化神经网络", "动态感受野", "多尺度特征融合", "移动端部署"),
  keywords-en: ("facial expression recognition", "lightweight neural network", "dynamic receptive field", "multi-scale feature fusion", "mobile deployment"),
)[
  人脸表情识别是计算机视觉领域的重要研究方向，在智能监控、人机交互及在线教育等场景中具有广泛应用。然而，传统深度卷积神经网络普遍存在参数量大、计算复杂度高等问题，难以部署于资源受限的边缘设备。针对这一矛盾，本文以 MobileNetV3Small 为 Backbone，提出了一种引入动态感受野机制的轻量化表情识别模型——Dynamic-MobileNetV3Small。

  在数据预处理阶段，针对 FerPlus 数据集原始图像分辨率低（48×48）且光照条件复杂的问题，本文设计了一套结合超分辨率重建与 CLAHE 光照增强的预处理流程。通过对比 NEAREST、LINEAR、CUBIC 与 LANCZOS4 四种插值方法，确定 CUBIC 双三次插值为最优方案；消融实验表明，CLAHE 增强使总体准确率由 67.39% 提升至 81.31%，提升幅度达 13.92 个百分点，Disgust 与 Contempt 等极端困难类别获得了显著改善。

  在模型设计方面，本文的核心创新在于提出了 Dynamic Receptive Field Block。该模块通过并行 3×3 与 5×5 Depthwise Convolution 提取多尺度表情特征，并利用全局平均池化与 Softmax 机制生成自适应权重，动态融合不同感受野的特征信息，使模型能够针对不同表情类别自适应选择最优感受野范围。

  实验结果表明，Dynamic-MobileNetV3Small 在 FerPlus 数据集上以最小的模型体积（1.23 MB）和最低的计算量（0.05 GFLOPs），取得了 82.73% 的总体准确率与 82.24% 的 F1-Score，超越 ResNet18、ResNet18+CBAM、ResNet18+ViT、MobileNetV1/V2/V3Small 等全部对比模型。消融实验进一步显示，动态感受野模块使准确率提升 2.68 个百分点，同时参数量下降 19.6%，平均置信度由 0.6542 跃升至 0.8275；在 Sadness（+15.75%）与 Contempt（+14.81%）等困难类别上的提升尤为突出。本文提出的模型在轻量化与识别精度之间取得了良好平衡，为移动端与边缘设备上的实时表情识别提供了一种有效方案。
][
  Facial expression recognition is an important research direction in computer vision with broad applications in intelligent surveillance, human-computer interaction, and online education. However, traditional deep convolutional neural networks generally suffer from large parameter sizes and high computational complexity, making them difficult to deploy on resource-constrained edge devices. To address this challenge, this thesis takes MobileNetV3Small as the backbone and proposes a lightweight facial expression recognition model incorporating a dynamic receptive field mechanism, termed Dynamic-MobileNetV3Small.

  In the data preprocessing stage, to address the low resolution (48×48) and complex illumination conditions of the FerPlus dataset, a preprocessing pipeline combining super-resolution reconstruction and CLAHE illumination enhancement is designed. By comparing four interpolation methods — NEAREST, LINEAR, CUBIC, and LANCZOS4 — CUBIC bicubic interpolation is identified as the optimal approach. Ablation experiments demonstrate that CLAHE enhancement improves the overall accuracy from 67.39% to 81.31%, an increase of 13.92 percentage points, with particularly notable gains on extremely difficult classes such as Disgust and Contempt.

  In terms of model design, the core innovation of this thesis lies in the proposed Dynamic Receptive Field Block. This module extracts multi-scale expression features through parallel 3×3 and 5×5 depthwise convolutions, and employs global average pooling with a Softmax mechanism to generate adaptive weights that dynamically fuse information from different receptive fields. This enables the model to adaptively select the optimal receptive field range for different expression categories.

  Experimental results show that Dynamic-MobileNetV3Small achieves an overall accuracy of 82.73% and an F1-Score of 82.24% on the FerPlus dataset with the smallest model size (1.23 MB) and the lowest computational cost (0.05 GFLOPs), outperforming all compared models including ResNet18, ResNet18+CBAM, ResNet18+ViT, and MobileNetV1/V2/V3Small. Ablation experiments further reveal that the dynamic receptive field module improves accuracy by 2.68 percentage points while reducing parameter count by 19.6%, and boosts the mean confidence from 0.6542 to 0.8275. Particularly significant improvements are observed on difficult classes such as Sadness (+15.75%) and Contempt (+14.81%). The proposed model achieves a favorable balance between lightweight design and recognition accuracy, providing an effective solution for real-time facial expression recognition on mobile and edge devices.
]
// 显示目录
#outline()

// 设置文档主体的格式
#show: mainmatter


= 绪论

== 研究背景与意义

=== 人脸表情识别的发展现状

人脸表情是人类情感表达的重要方式之一。心理学研究表明，在人与人的交流过程中，面部表情能够传递大量情绪与行为信息，因此对人脸表情进行自动识别具有重要的理论意义与应用价值。随着人工智能、计算机视觉以及深度学习技术的快速发展，人脸表情识别（Facial Expression Recognition，FER）逐渐成为智能感知领域的重要研究方向，并广泛应用于智能监控、人机交互、在线教育、驾驶行为分析以及医疗辅助等场景。

传统的人脸表情识别方法主要包括人脸检测、特征提取与分类识别三个阶段。早期研究通常采用人工设计特征的方法，例如局部二值模式（LBP）@ojala2002lbp、方向梯度直方图（HOG）@dalal2005hog、Gabor 小波特征等。这类方法具有实现简单、计算量较小等优点，但由于其特征表达能力有限，容易受到光照变化、遮挡、姿态变化以及个体差异等因素影响，因此在复杂场景中的识别效果较差。

近年来，深度学习技术的兴起极大推动了表情识别领域的发展。卷积神经网络（CNN）@lecun1998lenet 能够通过多层卷积结构自动学习图像深层语义特征，相比传统方法具有更强的特征提取能力。以 AlexNet@krizhevsky2012alexnet、VGGNet@simonyan2014vgg、ResNet@he2016resnet 为代表的深度卷积网络在多个公开表情识别数据集上取得了较高准确率。与此同时，Transformer 结构@vaswani2017transformer 与注意力机制逐渐被引入表情识别任务，通过增强模型对关键区域的关注能力进一步提升识别性能。

然而，随着网络深度不断增加，模型参数量与计算复杂度也迅速提升。高性能模型通常需要大量计算资源支持，难以直接部署于移动端与嵌入式设备中。因此，如何在保证识别精度的同时降低模型复杂度与计算开销，逐渐成为当前表情识别研究中的重点问题。

=== 轻量化神经网络的发展趋势

随着移动互联网、物联网以及边缘计算技术的不断发展，深度学习模型逐渐从高性能服务器向移动终端与边缘设备迁移。然而，传统深度卷积神经网络通常存在参数量庞大、计算复杂度高以及推理速度慢等问题，难以满足实时应用需求。因此，轻量化神经网络逐渐成为深度学习领域的重要研究方向。

轻量化网络的核心目标是在减少模型参数量与计算量的同时，尽可能保持较高的识别性能。目前主流的轻量化方法主要包括深度可分离卷积@chollet2017xception、模型剪枝、参数量化以及知识蒸馏等。其中，以 MobileNet、ShuffleNet@zhang2018shufflenet 与 EfficientNet@tan2019efficientnet 为代表的轻量化卷积神经网络在移动端视觉任务中得到了广泛应用。

MobileNetV1@howard2017mobilenetv1 首次提出深度可分离卷积结构，将标准卷积分解为 Depthwise Convolution 与 Pointwise Convolution，大幅减少了模型计算量。MobileNetV2@sandler2018mobilenetv2 在此基础上引入倒残差结构与线性瓶颈结构，进一步提升了特征表达能力。MobileNetV3@howard2019mobilenetv3 结合神经网络架构搜索（NAS）@zoph2018nas 与注意力机制，在准确率与推理效率之间取得了更优平衡。

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

在纹理特征方面，局部二值模式（LBP）@ojala2002lbp 由于具有较强的灰度不变性，被广泛应用于表情识别任务。Gabor 小波特征能够有效提取不同方向与尺度的纹理信息，在复杂表情特征建模中具有较好效果。方向梯度直方图（HOG）@dalal2005hog 则通过统计图像局部梯度方向信息实现特征描述。

在分类方法方面，传统研究通常采用支持向量机（SVM）@cortes1995svm、K 近邻（KNN）以及 Adaboost 等机器学习算法完成表情分类任务。虽然传统方法在小规模数据集上具有一定效果，但由于其依赖人工经验设计特征，因此泛化能力有限，难以适应复杂环境下的人脸表情识别任务。

=== 基于深度学习的表情识别研究现状

随着深度学习技术的发展，卷积神经网络逐渐成为表情识别领域的主流方法。CNN 能够自动学习图像深层语义特征，相比传统人工特征具有更强的表达能力。

VGGNet@simonyan2014vgg 通过增加网络深度提升特征提取能力，在表情识别任务中取得了较好效果。ResNet@he2016resnet 引入残差结构，有效解决了深层网络训练中的梯度消失问题，提高了模型训练稳定性。近年来，注意力机制与 Transformer 结构逐渐应用于表情识别领域，例如 CBAM@woo2018cbam 能够增强模型对关键通道与空间区域的关注能力，而 Vision Transformer（ViT）@dosovitskiy2020vit 则通过全局特征建模提升复杂表情识别能力。

此外，多尺度特征融合逐渐成为研究热点。由于不同表情在面部区域中的特征分布差异明显，研究者开始通过不同尺度卷积核提取局部与全局特征，从而增强模型对复杂表情的识别能力。

=== 轻量化神经网络研究现状

随着移动端视觉应用需求不断增加，轻量化神经网络研究逐渐受到广泛关注。MobileNet 系列网络通过深度可分离卷积显著降低模型计算量，在移动设备中具有较高应用价值。ShuffleNet@zhang2018shufflenet 通过通道重排机制减少计算复杂度，提高网络运行效率。EfficientNet@tan2019efficientnet 则采用复合缩放策略，在模型深度、宽度与输入分辨率之间实现平衡优化。

近年来，研究者开始将轻量化网络应用于表情识别任务，通过减少参数量与计算量提升模型实时性能。然而，由于轻量化模型特征提取能力相对有限，在复杂场景下容易出现识别精度下降问题。因此，如何进一步增强轻量化模型的特征表达能力，仍是当前研究的重要方向。

=== 注意力机制与动态感受野研究现状

注意力机制能够通过增强模型对关键区域的关注能力，提高特征提取效果。目前常见注意力机制包括 SENet@hu2018senet、CBAM@woo2018cbam 与 ECA@wang2020ecanet 等。其中，CBAM 同时结合通道注意力与空间注意力，能够有效提升模型对关键面部区域的特征感知能力。

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

#imagex(
  image("figures/tech_roadmap.png", width: 100%),
  caption: [本文技术路线图],
  label-name: "img-tech_roadmap",
)

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

ReLU（Rectified Linear Unit）@nair2010relu 由于计算简单、训练速度快以及能够缓解梯度消失问题，被广泛应用于深度卷积神经网络中。

MobileNetV3Small 中采用了 h-swish 激活函数。相比传统 ReLU 与 Swish 函数，h-swish 在保持较好性能的同时具有更低计算开销，更适用于移动端与轻量化网络。

=== Batch Normalization

Batch Normalization（BN）@ioffe2015batchnorm 是一种常用的特征归一化方法，其主要作用是在网络训练过程中对输入特征进行标准化处理，从而缓解内部协变量偏移问题。

BN 能够加快模型收敛速度，提高训练稳定性，并在一定程度上减轻过拟合现象。因此，在现代卷积神经网络中通常会在卷积层后加入 Batch Normalization 层。

=== 损失函数与优化器

损失函数用于衡量模型预测结果与真实标签之间的差异，是模型训练的重要组成部分。在表情识别任务中，通常采用交叉熵损失函数（Cross Entropy Loss）完成多分类训练。

优化器用于根据损失函数更新网络参数。常见优化器包括 SGD、Momentum 与 Adam 等。其中，Adam 优化器@kingma2014adam 结合了动量优化与自适应学习率机制，具有收敛速度快、训练稳定等优点，因此在深度学习任务中应用广泛。

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

MobileNetV1 是最早提出的轻量化 MobileNet 网络，其核心思想是采用深度可分离卷积（Depthwise Separable Convolution）@chollet2017xception 替代传统标准卷积，从而显著降低模型计算量。

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

MobileNetV3Small 在网络结构中引入了 SE（Squeeze-and-Excitation）注意力机制@hu2018senet，通过学习不同通道的重要性增强关键特征表达能力。同时，网络采用更加高效的 h-swish 激活函数替代传统 ReLU，提高模型非线性表达能力。

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

#imagex(
  image("figures/cbam_structure.png", width: 100%),
  caption: [CBAM 注意力机制结构图],
  label-name: "img-cbam_structure",
)

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

近年来，多尺度卷积结构被广泛应用于轻量化网络中。例如 Inception 模块@szegedy2015inception 通过并行不同尺度卷积核实现多尺度特征融合，提高模型特征表达能力。

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

FerPlus 是在 FER2013@goodfellow2013fer2013 数据集基础上重新标注得到的人脸表情识别数据集。相比原始 FER2013 数据集，FerPlus@barsoum2016ferplus 采用多标签投票方式重新标注表情类别，从而提高了标签准确性与数据质量。

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

RAF-DB（Real-world Affective Faces Database）@li2017rafdb 是一个面向真实场景的人脸表情识别数据集，由大量互联网自然场景图像组成，能够较好反映复杂环境下的人脸表情变化情况。

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

在实际场景中，人脸图像常受到环境光照变化的影响，容易出现亮度不均、阴影遮挡及局部对比度不足等问题，从而降低表情特征的可辨识性。为增强图像局部区域的细节信息，本文采用限制对比度自适应直方图均衡化（Contrast Limited Adaptive Histogram Equalization，CLAHE）@pizer1987clahe 方法对图像进行光照增强处理。

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

#imagex(
  image("figures/data_augmentation_visualization.png", width: 70%),
  caption: [数据增强示例],
  label-name: "img-data-augment",
)

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

本文构建了一种基于轻量化神经网络的表情识别系统，系统主要包括数据预处理、模型训练以及表情识别三个部分。整体系统以 MobileNetV3Small 为基础网络，通过引入动态感受野模块增强模型对多尺度表情特征的提取能力，在保持较低计算复杂度的同时提高表情识别准确率。

系统整体流程主要包括图像输入、数据预处理、特征提取以及表情分类等步骤。首先，对输入图像进行超分辨率重建与 CLAHE 光照增强，提高图像质量；随后，通过轻量化卷积神经网络提取深层表情特征；最后，通过分类器输出最终表情类别结果。

#imagex(
  image("figures/fer-allv2.png", width: 100%),
  caption: [轻量化表情识别全流程],
  label-name: "img-fer-all",
)

=== 系统功能模块

本文设计的轻量化表情识别系统主要由以下几个功能模块组成：

(1) 数据预处理模块

数据预处理模块主要负责图像增强与格式统一。由于 FerPlus 数据集原始分辨率较低，因此首先采用超分辨率重建方法将图像由：
$48 times 48$
提升至：
$224 times 224$

随后，利用 CLAHE 光照增强算法改善图像亮度与对比度，提高模型对复杂光照环境的适应能力。此外，在训练阶段还采用随机翻转、随机裁剪以及随机旋转等数据增强方法，提高模型泛化能力。

(2) 特征提取模块

特征提取模块是系统核心部分。本文以 MobileNetV3Small 为基础 Backbone 网络，并在其基础上引入 Dynamic Receptive Field Block。

该模块通过并行不同尺度的 Depthwise Convolution 提取多尺度表情特征，使模型能够更加有效地关注不同表情对应的关键区域，从而增强模型特征表达能力。

(3) 表情分类模块

分类模块主要负责对提取到的深层特征进行分类识别。网络最后通过全局平均池化层与全连接层输出不同表情类别概率，并利用 Softmax 分类器得到最终识别结果。

系统最终能够实现对高兴、悲伤、愤怒、惊讶、中性等多种表情类别的自动识别。

=== 模型训练流程

本文模型训练流程主要包括数据加载、数据增强、模型训练以及模型评估等步骤。

首先，对 FerPlus 与 RAF-DB 数据集进行读取与预处理，并按照训练集、验证集以及测试集进行划分。随后，在训练阶段采用随机数据增强方法提高模型鲁棒性。

模型训练过程中，将预处理后的人脸图像输入 Dynamic-MobileNetV3Small 网络中，通过前向传播提取表情特征，并利用交叉熵损失函数计算预测结果与真实标签之间的误差。

随后，通过反向传播算法更新网络参数，并采用 Adam 优化器完成模型训练。在训练过程中，系统会记录模型准确率与损失函数变化情况，并保存最佳模型参数。

实验环境基于 Ubuntu 22.04 操作系统，使用 PyTorch 深度学习框架完成模型训练与测试，硬件平台采用 NVIDIA A100 GPU，以提高模型训练效率。

=== 表情识别流程

在实际表情识别过程中，系统首先获取输入人脸图像，并对图像进行尺寸调整与归一化处理。

随后，经过超分辨率重建与 CLAHE 光照增强后，图像被输入 Dynamic-MobileNetV3Small 网络进行特征提取。网络通过动态感受野模块自动关注不同尺度的重要表情区域，例如眼部、眉毛以及嘴角区域。

最后，模型通过 Softmax 分类器输出各表情类别概率，并将概率最大的类别作为最终识别结果。

整个系统在保持较低计算复杂度的同时，能够实现较高准确率的人脸表情识别，适用于移动端与边缘设备中的实时视觉任务。

== 基础对比模型设计

为了验证本文提出 Dynamic-MobileNetV3Small 模型的有效性，实验选取了多种主流卷积神经网络与轻量化网络作为对比模型，包括 ResNet18、ResNet18 + CBAM、ResNet18 + ViT、MobileNetV1、MobileNetV2 以及 MobileNetV3Small 等模型。

这些模型在网络结构、特征提取方式以及轻量化程度方面具有一定代表性，能够较好地反映不同模型在表情识别任务中的性能差异。

=== ResNet18 模型

ResNet18 是经典残差网络（Residual Network）中的基础模型之一，由多个残差模块堆叠组成。ResNet18 通过引入残差连接（Residual Connection）有效缓解了深层网络训练中的梯度消失问题，提高了模型训练稳定性。

残差结构的核心思想是通过恒等映射将输入特征直接传递到输出端，使网络能够更加容易学习特征残差，从而提高模型收敛速度与特征表达能力。

由于 ResNet18 网络结构较为简单，同时具有较好的特征提取能力，因此被广泛应用于图像分类与人脸表情识别任务中。本文将其作为基础对比模型，用于分析不同轻量化模型的性能差异。

=== ResNet18 + CBAM 模型

为了增强网络对关键区域特征的关注能力，本文在 ResNet18 基础上引入 CBAM（Convolutional Block Attention Module）注意力机制，构建 ResNet18 + CBAM 模型。

CBAM 主要包括通道注意力与空间注意力两个部分。通道注意力用于学习不同通道的重要程度，而空间注意力则用于增强模型对关键区域的关注能力。

在人脸表情识别任务中，不同表情通常对应不同关键区域。例如，“高兴”表情主要体现在嘴角区域，而“愤怒”表情则更加依赖眼部与眉毛特征。因此，引入注意力机制能够有效增强模型对重要区域的特征提取能力。

通过该模型，可以分析注意力机制对于表情识别性能提升的影响。

=== ResNet18 + ViT 模型

近年来，Transformer 结构逐渐被应用于计算机视觉领域。相比传统卷积神经网络，Vision Transformer（ViT）能够利用自注意力机制建模图像全局特征关系，从而提高复杂视觉任务中的特征表达能力。

本文在 ResNet18 基础上结合 Vision Transformer 模块，构建 ResNet18 + ViT 模型。该模型首先利用卷积网络提取局部特征，随后通过 Transformer 结构学习不同区域之间的全局特征关系。

相比传统卷积结构，ViT 能够更有效地捕获远距离特征依赖关系，因此在复杂场景下具有较强表现能力。然而，由于 Transformer 结构计算复杂度较高，因此在轻量化任务中的部署仍存在一定挑战。

本文通过该模型分析 Transformer 结构在人脸表情识别任务中的性能表现。

=== MobileNetV1 模型

MobileNetV1 是经典轻量化卷积神经网络，其核心思想是采用深度可分离卷积（Depthwise Separable Convolution）替代传统标准卷积，从而显著降低模型参数量与计算复杂度。

相比传统卷积网络，MobileNetV1 能够在保持较低计算量的同时实现较好识别性能，因此被广泛应用于移动端视觉任务。

然而，由于网络结构较浅，MobileNetV1 的特征表达能力相对有限，在复杂表情识别任务中容易出现准确率下降问题。

=== MobileNetV2 模型

MobileNetV2 在 MobileNetV1 基础上进一步优化网络结构，引入了倒残差结构（Inverted Residual）与线性瓶颈结构（Linear Bottleneck）。

倒残差结构首先通过 $1 times 1$ 卷积扩展通道数，然后利用深度可分离卷积提取特征，最后再通过 $1 times 1$ 卷积压缩通道数，从而在降低模型复杂度的同时提高特征表达能力。

此外，MobileNetV2 使用线性激活函数减少低维空间中的信息损失，因此相比 MobileNetV1 具有更好的识别性能与训练稳定性。

=== MobileNetV3Small 模型

MobileNetV3 是在 MobileNetV2 基础上进一步优化得到的轻量化网络，其结合了神经网络架构搜索（NAS）与注意力机制，在准确率与推理效率之间取得了更优平衡。

本文采用 MobileNetV3Small 作为基础 Backbone 网络。相比 MobileNetV3Large，MobileNetV3Small 更适用于移动端与边缘设备中的实时任务。

MobileNetV3Small 在网络结构中引入 SE 注意力机制，并采用 h-swish 激活函数替代传统 ReLU，从而提高模型非线性表达能力与特征提取效率。

由于其具有较低 FLOPs 与较好识别性能，因此 MobileNetV3Small 成为本文 Dynamic-MobileNetV3Small 模型改进的基础网络结构。

== Dynamic-MobileNetV3Small 模型设计

为了进一步提高轻量化表情识别模型对复杂表情特征的提取能力，本文在 MobileNetV3Small 基础上提出了一种 Dynamic-MobileNetV3Small 模型。该模型通过引入 Dynamic Receptive Field Block，在保持较低计算复杂度的同时增强网络对多尺度表情特征的建模能力，从而提高模型整体识别性能。

本文的核心改进主要体现在深度可分离卷积部分。传统 MobileNetV3Small 使用固定卷积核进行特征提取，而本文提出的动态感受野结构能够根据输入特征动态调整不同尺度卷积核的重要性，使模型更加适应不同表情区域的特征变化。

=== 网络整体结构

本文提出的 Dynamic-MobileNetV3Small 以 MobileNetV3Small 为基础 Backbone 网络，整体网络结构仍然保持轻量化设计思想。

网络前部主要负责低层特征提取，包括边缘、纹理以及局部结构信息；中后部网络则负责高层语义特征提取，用于学习不同表情对应的深层特征信息。

在模型改进过程中，本文并未改变 MobileNetV3Small 的整体网络框架，而是将其中部分 Depthwise Convolution 替换为本文提出的 Dynamic Receptive Field Block，从而在尽量不增加模型参数量的条件下增强网络多尺度特征提取能力。

此外，在分类部分，本文采用全局平均池化与全连接层完成最终表情分类，并利用 Dropout@srivastava2014dropout 减轻模型过拟合问题。

#imagex(
  image("figures/dyn_mnetv3_arch.png", width: 100%),
  caption: [Dynamic-MobileNetV3Small 网络整体结构图],
  label-name: "img-dyn_mnetv3_arch",
)

=== Dynamic Receptive Field Block 设计

Dynamic Receptive Field Block 是本文提出模型的核心结构，其主要目标是增强网络对不同尺度表情特征的建模能力。

传统卷积结构通常采用固定大小卷积核，因此感受野范围固定，难以同时兼顾局部细节特征与全局语义特征。而在人脸表情识别任务中，不同表情对应的关键区域尺度存在明显差异。

例如：

--“高兴”表情通常更加依赖嘴角局部变化；

--“惊讶”表情则涉及更大范围的面部肌肉变化。

因此，固定感受野卷积难以充分适应复杂表情特征。

为解决该问题，本文提出 Dynamic Receptive Field Block，通过并行不同尺度 Depthwise Convolution 提取多尺度特征，并利用动态权重融合机制自适应调整不同感受野的重要程度，从而提高模型特征表达能力。

整个模块主要包括：

+ 并行多尺度 Depthwise Convolution
+ 全局特征感知
+ 自适应权重生成
+ 动态特征融合

#imagex(
  image("figures/drf_block_detail.png", width: 100%),
  caption: [Dynamic Receptive Field Block 详细结构图],
  label-name: "img-drf_block_detail",
)

=== 并行 3×3 与 5×5 Depthwise Conv

在 Dynamic Receptive Field Block 中，本文采用并行的：
$3 times 3$,
$5 times 5$
Depthwise Convolution 提取不同尺度特征。

其中：

--$3 times 3$ 卷积更加关注局部细粒度纹理信息；

--$5 times 5$ 卷积能够获取更加广泛的上下文特征。

Depthwise Convolution 采用逐通道卷积方式，其每个卷积核仅作用于单独输入通道，因此相比传统卷积具有更低计算复杂度。

设输入特征为：$x$

则模块输出可以表示为：

$x_3 = "DWConv"_(3 times 3)(x)$

$x_5 = "DWConv"_(5 times 5)(x)$

通过同时提取不同尺度特征，模型能够更加有效地学习复杂表情中的局部与全局信息，从而提高表情识别能力。

=== 自适应权重融合机制

为了动态调整不同感受野的重要程度，本文设计了一种自适应权重融合机制。

首先，对输入特征进行全局平均池化（Global Average Pooling），获取全局上下文信息：$x_g = "GAP"(x)$

随后，通过全连接层生成不同卷积尺度对应的权重系数：$w = "Softmax"("FC"(x_g))$

其中：$w_3$, $w_5$
分别表示：$3 times 3$, $5 times 5$

卷积对应的动态权重。

最终输出结果为： $y = w_3 x_3 + w_5 x_5$

通过 Softmax 函数约束权重和为 1，使模型能够根据输入表情特征动态选择更加合适的感受野范围。

相比固定卷积结构，该方法能够增强模型对复杂表情区域的自适应建模能力。

=== 特征融合流程

Dynamic Receptive Field Block 的整体特征融合流程如下：

(1) 输入特征首先进入并行多尺度 Depthwise Convolution 分支；

(2) 不同尺度卷积分别提取局部特征与大范围上下文特征；

(3) 输入特征通过全局平均池化生成全局上下文信息；

(4) 利用全连接层与 Softmax 函数生成动态权重；

(5) 对不同尺度特征进行加权融合；

(6) 输出融合后的多尺度表情特征。

该结构能够根据不同输入表情动态调整感受野范围，使模型更加关注关键区域特征，同时保持较低计算复杂度。

实验结果表明，本文提出的 Dynamic-MobileNetV3Small 模型在仅约 0.05 GFLOPs 的计算量条件下，实现了较高表情识别准确率，验证了动态感受野机制在轻量化表情识别任务中的有效性。

= 实验设计与结果分析

== 实验环境配置

为了验证本文提出 Dynamic-MobileNetV3Small 模型的有效性，本文基于 Ubuntu Linux 平台搭建深度学习实验环境，并使用 PyTorch 深度学习框架完成模型训练与测试。实验过程中采用高性能 GPU 服务器进行模型训练，以保证模型训练效率与实验结果稳定性。

=== 硬件环境

本文实验服务器采用 Intel Xeon 高性能多核处理器与 NVIDIA A100 GPU 作为主要计算平台，具体硬件配置如下：

#table(
  columns: (35%, 65%),
  align: center,
  table.header(
    [硬件设备], [配置参数]
  ),

  [CPU], [Intel(R) Xeon(R) Platinum 8360Y @ 2.40GHz],

  [CPU 核心数], [144 Threads / 72 Cores],

  [GPU], [NVIDIA A100-SXM4-80GB × 8],

  [GPU 显存], [80GB HBM2e],

  [GPU 驱动版本], [550.163.01],

  [CUDA 版本], [CUDA 12.4],

  [内存], [服务器高容量内存环境]
)

其中，NVIDIA A100 GPU 具有较强并行计算能力，能够显著提高深度卷积神经网络训练速度。同时，多 GPU 环境能够支持大规模数据训练与复杂模型实验。

=== 软件环境

本文实验采用 Ubuntu Linux 操作系统，并基于 Python 深度学习环境完成模型训练与测试。具体软件环境配置如下：

#table(
  columns: (35%, 65%),
  align: center,
  table.header(
    [软件环境], [版本]
  ),

  [操作系统], [Ubuntu 22.04 LTS],

  [Linux 内核], [5.15.0-94-generic],

  [Python], [Python 3.10.20],

  [PyTorch], [2.5.1],

  [Torchvision], [0.20.1],

  [CUDA], [12.4],

  [OpenCV], [4.13.0],

  [NumPy], [2.0.1],

  [Scikit-learn], [1.7.2]
)

此外，实验过程中还使用：

- Matplotlib 用于实验结果可视化；
- THOP 用于模型 FLOPs 与参数量统计；
- Timm 用于部分模型结构支持；
- Pandas 用于实验数据分析。

整个实验环境均基于 Conda 虚拟环境进行管理，以保证实验依赖稳定性与可复现性。

=== PyTorch 深度学习框架

本文实验基于 PyTorch 深度学习框架@paszke2019pytorch 完成模型设计、训练与测试。PyTorch 是目前主流深度学习框架之一，具有动态图机制灵活、开发效率高以及 GPU 加速支持完善等特点，因此被广泛应用于计算机视觉研究领域。

在模型训练过程中，本文主要使用 PyTorch 完成以下功能：

- 神经网络模型构建；
- 数据加载与预处理；
- 前向传播与反向传播；
- GPU 并行训练；
- 模型参数保存与加载；
- 损失函数与优化器实现。

此外，PyTorch 对 CUDA GPU 具有良好支持，能够充分利用 NVIDIA A100 GPU 的并行计算能力，提高模型训练效率。

在实验过程中，本文采用 Adam 优化器完成模型参数更新，并使用交叉熵损失函数进行多分类训练。同时，利用 DataLoader 实现数据批量加载，提高训练过程中的数据读取效率。

相比传统深度学习框架，PyTorch 具有更好的可扩展性与代码可读性，能够方便实现本文提出的 Dynamic Receptive Field Block 等自定义网络结构。

== 模型训练参数设置

为了保证实验结果的稳定性与模型训练效率，本文对模型训练过程中的 Batch Size、学习率、优化器以及损失函数等关键参数进行了统一设置。所有模型均在相同实验环境下完成训练，以保证实验结果具有公平性与可比性。

=== Batch Size 设置

Batch Size 表示每次迭代过程中输入模型的样本数量，其大小会直接影响模型训练速度与显存占用情况。

本文实验服务器采用 NVIDIA A100-SXM4-80GB GPU，具有较大显存容量，因此能够支持较大的 Batch Size 设置。综合考虑训练稳定性与显存消耗，本文最终将 Batch Size 设置为：

$"Batch_Size" = 32$

较大的 Batch Size 能够提高 GPU 并行计算效率，同时降低梯度波动，提高模型训练稳定性。

此外，训练过程中采用 PyTorch DataLoader 进行数据批量加载，并结合多线程数据读取方式提高数据加载效率。其中：

--num_workers 设置为 16；

--prefetch_factor 设置为 2。

该设置能够有效减少数据读取过程中的 CPU 与 GPU 等待时间，提高整体训练效率。

=== 学习率设置

学习率（Learning Rate）用于控制模型参数更新幅度，是影响模型收敛速度与训练稳定性的关键参数之一。

若学习率过大，模型容易出现震荡甚至无法收敛；若学习率过小，则会导致训练速度较慢，甚至陷入局部最优。

本文实验初始学习率设置为：

$lr = 0.0005$

同时，为提高模型后期训练稳定性，本文采用 StepLR 学习率衰减策略。在训练过程中，每经过一定 Epoch 后自动降低学习率，其参数设置如下：

--step\_size = 20

--gamma = 0.1

即每训练 20 个 Epoch，学习率缩小为原来的：$0.1$

该方法能够在训练前期保持较快收敛速度，同时在后期提高模型稳定性与最终识别精度。

=== 优化器选择

优化器用于根据损失函数计算结果更新模型参数，不同优化器会对模型收敛速度与最终性能产生影响。

本文采用 Adam（Adaptive Moment Estimation）优化器完成模型训练，其具有自适应学习率调整能力，能够结合梯度一阶矩与二阶矩信息动态更新模型参数。

相比传统 SGD 优化器，Adam 具有：

- 收敛速度更快；
- 参数更新更加稳定；
- 更适合复杂深度网络训练。

本文优化器参数设置如下：

#table(
  columns: (40%, 60%),
  align: center,
  table.header(
    [参数], [设置值]
  ),

  [优化器], [Adam],

  [学习率], [0.0005],

  [Weight Decay], [$1 times 10^(-4)$]
)

其中，Weight Decay 用于实现 L2 正则化，从而减轻模型过拟合问题，提高模型泛化能力。

=== 损失函数设置

由于人脸表情识别数据集通常存在类别不平衡问题，例如：

- Happy 类样本较多；
- Disgust 与 Fear 类样本较少。

若直接采用普通交叉熵损失函数，模型容易偏向样本数量较多的类别，从而影响整体识别性能。

因此，本文采用 Focal Loss@lin2017focalloss 作为模型损失函数，并结合类别权重机制增强模型对困难样本与少样本类别的学习能力。

Focal Loss 在交叉熵损失基础上增加难样本调节因子，其能够降低易分类样本对整体损失的影响，使模型更加关注难分类样本。

本文设置：

$gamma = 2.0$

同时，根据训练集类别分布动态计算类别权重，并对权重进行平方根平滑处理，从而减轻类别不平衡问题。

最终损失函数形式如下：

$"Loss = FocalLoss(weight,gamma)"$

实验结果表明，采用 Focal Loss 后，模型在 Fear、Disgust 等少样本类别上的识别准确率得到明显提升，提高了整体模型鲁棒性与分类性能。

== 模型对比实验

为了验证本文提出 Dynamic-MobileNetV3Small 模型的有效性，本文选取 ResNet18、ResNet18 + CBAM、ResNet18 + Transformer、MobileNetV1、MobileNetV2 以及 MobileNetV3Small 等多种主流模型进行对比实验。

实验主要从模型准确率、参数规模、FLOPs、F1-Score 以及推理效率等方面进行综合分析，从而验证本文模型在轻量化与识别性能之间的平衡能力。

各模型实验结果如表所示。

#{
  // 读取文件，分隔符可以为分号
  let result = csv("data/output_模型性能对比表_含RAF-DB.csv_20260512_132808.csv", delimiter: ",")

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
    label-name: "class-stats2",
  )
}

=== 不同模型准确率对比

从实验结果可以看出，传统 ResNet18 模型虽然具有较强特征提取能力，但由于网络结构较为庞大，其整体准确率仅达到：

$74.23%$

在引入 CBAM 注意力机制后，ResNet-CBAM 模型准确率提升至：

$75.17%$

说明注意力机制能够增强模型对关键表情区域的关注能力，从而提高识别性能。

ResNet-Transformer 模型通过引入 Transformer 全局特征建模结构，准确率进一步提升至：

$78.54%$

但其计算复杂度显著增加，GFLOPs 高达：

$28.43$

难以满足轻量化实时识别需求。

相比传统卷积网络，MobileNet 系列模型表现出更好的轻量化性能。其中：

- MobileNetV1 准确率为 $77.48%$
- MobileNetV2 准确率为 $79.21%$
- MobileNetV3Small 准确率达到 $81.23%$

说明轻量化网络在保持较低计算复杂度的同时，仍能够取得较好识别性能。

本文提出的 Dynamic-MobileNetV3Small 模型最终取得：

$82.73%$

的总体识别准确率，相比原始 MobileNetV3Small 提升约：

$1.5%$

验证了动态感受野机制对于表情特征提取的有效性。

=== 参数量与 FLOPs 对比

从模型规模与计算复杂度角度分析，ResNet 系列模型整体参数量与 FLOPs 较高。

其中：

- ResNet18 模型大小为 $11.18"MB"$
- ResNet-Transformer 达到 $11.99"MB"$

同时，Transformer 结构引入后模型计算量显著增加，不利于移动端部署。

相比之下，MobileNet 系列模型采用深度可分离卷积结构，大幅降低了模型参数量与计算复杂度。

其中：

- MobileNetV3Small 模型大小仅为 $1.53"MB"$
- FLOPs 为 $0.06$

本文提出的 Dynamic-MobileNetV3Small 模型在引入动态感受野结构后，模型大小进一步降低至：

$1.23"MB"$

同时整体计算量仅为：

$0.05 "GFLOPs"$

说明本文提出的方法在增强模型特征表达能力的同时，并未明显增加模型复杂度，仍然保持较强轻量化特性。

=== F1-Score 对比

F1-Score 能够综合反映模型精确率与召回率，因此更加适用于类别不平衡的人脸表情识别任务。

实验结果表明：

- ResNet18 F1-Score 为 $72.73%$
- ResNet-CBAM 提升至 $74.82%$
- ResNet-Transformer 达到 $77.21%$

而 MobileNet 系列整体表现更加优秀：

- MobileNetV1 为 $77.10%$
- MobileNetV2 为 $78.88%$
- MobileNetV3Small 达到 $80.03%$

本文提出的 Dynamic-MobileNetV3Small 最终取得：

$82.24%$

的 F1-Score，为所有模型中最高。

说明本文提出的动态感受野结构能够更加有效地提取复杂表情特征，提高模型整体分类性能，尤其在少样本类别中具有更好鲁棒性。

=== 推理效率对比

在人脸表情识别任务中，模型推理效率对于实时应用具有重要意义。

传统 ResNet 与 Transformer 类模型虽然具有较强特征表达能力，但由于参数量与 FLOPs 较高，其推理速度相对较慢。

特别是 ResNet-Transformer 模型，其 GFLOPs 高达：

$28.43$

在移动端设备中难以实现实时部署。

相比之下，MobileNet 系列模型由于采用深度可分离卷积结构，能够显著提高推理效率。

其中，Dynamic-MobileNetV3Small 在仅：

$0.05 "GFLOPs"$

计算量条件下实现：

$82.73%$

准确率，说明其能够在保证较高识别性能的同时保持较快推理速度。

综合实验结果表明，本文提出的 Dynamic-MobileNetV3Small 模型在模型大小、计算复杂度以及识别性能之间取得了较好平衡，更适用于移动端与边缘设备中的实时表情识别任务。


== 消融实验

为了进一步验证本文所提出各模块设计的有效性，本文分别对数据预处理方法与模型结构进行了消融实验分析。实验主要包括：

- CLAHE 光照增强实验；
- Dynamic Receptive Field Block 消融实验；
- 多尺度卷积结构实验；
- 动态权重融合机制实验。

通过逐步添加不同模块并对比实验结果，分析各部分对于模型性能提升的贡献。

=== CLAHE 光照增强实验

在人脸表情识别任务中，图像光照条件对模型识别性能具有较大影响。在实际场景中，人脸图像常存在光照不均、阴影遮挡、曝光不足及局部亮度变化明显等问题，这些因素容易导致模型无法准确提取关键表情特征，从而降低整体识别精度。

因此，本文在数据预处理阶段引入 CLAHE（Contrast Limited Adaptive Histogram Equalization）光照增强方法。CLAHE 能够通过局部区域自适应直方图均衡化增强图像对比度，同时限制局部增强幅度，避免普通直方图均衡化带来的噪声放大问题。本文设置 CLAHE 的 `clipLimit` 参数为 $3.0$，局部网格大小为 $8 times 8$。

实验中，本文分别对使用 CLAHE 光照增强与不使用 CLAHE 光照增强两种情况进行了对比实验，其余训练参数保持一致。

#imagex(
  image("figures/ablation/clahe/clahe_accuracy_comparison.png", width: 80%),
  caption: [CLAHE 光照增强总体准确率对比],
  label-name: "img-clahe_accuracy_comparison",
)

从实验结果可以看出，加入 CLAHE 后模型总体准确率由 $67.39%$ 提升至 $81.31%$，整体准确率提升约 $13.92$ 个百分点。说明 CLAHE 能够显著增强模型对复杂光照环境的适应能力，提高表情特征提取效果。

此外，本文进一步统计了模型预测置信度分布情况，如图所示。

#imagex(
  image("figures/ablation/clahe/clahe_confidence_distribution.png", width: 100%),
  caption: [CLAHE 光照增强置信度分布对比],
  label-name: "img-clahe_confidence_distribution",
)

可以观察到：

-- 使用 CLAHE 后模型平均置信度达到 $0.8275$；
-- 未使用 CLAHE 时平均置信度仅为 $0.7887$，提升约 $0.0388$。

同时，加入 CLAHE 后高置信度样本数量明显增加，低置信度样本数量显著减少，说明模型预测结果更加稳定，分类边界更加清晰。

#imagex(
  image("figures/ablation/clahe/clahe_confidence_scatter.png", width: 100%),
  caption: [CLAHE 光照增强置信度散点分布对比],
  label-name: "img-clahe_confidence_scatter",
)

从置信度散点图可以更直观地看出，使用 CLAHE 后大量原本置信度偏低的样本被提升至高置信度区间，模型对预测结果的确定性整体增强。

为了进一步分析 CLAHE 对不同表情类别的影响，本文统计了各类别识别准确率，如图所示。

#imagex(
  image("figures/ablation/clahe/clahe_per_class_accuracy.png", width: 100%),
  caption: [CLAHE 光照增强各类别准确率对比],
  label-name: "img-clahe_per_class_accuracy",
)

从各类别实验结果可以发现，CLAHE 对绝大多数类别均具有明显提升作用，具体数据如下：

- Happiness：$65.07% → 89.10%$（$+24.03%$）；
- Surprise：$67.90% → 85.25%$（$+17.35%$）；
- Sadness：$36.99% → 69.45%$（$+32.46%$）；
- Anger：$44.17% → 73.93%$（$+29.75%$）；
- Disgust：$2.94% → 50.00%$（$+47.06%$）；
- Fear：$38.89% → 59.72%$（$+20.83%$）；
- Contempt：$0.00% → 29.63%$（$+29.63%$）。

其中，Disgust 类提升幅度最大，由几乎无法识别（$2.94%$）提升至 $50.00%$；Contempt 类更是在未使用 CLAHE 时完全无法正确分类（$0.00%$），加入 CLAHE 后准确率达到 $29.63%$。Sadness 与 Anger 等复杂表情类别同样获得 $30%$ 左右的显著提升。

值得注意的是，Neutral 类准确率由 $88.44%$ 略微下降至 $83.22%$（$-5.22%$）。这一现象的可能原因是 CLAHE 增强了 Neutral 样本中的局部纹理细节，使部分 Neutral 样本与 Sadness 或 Fear 等表情在特征空间中的边界发生偏移，从而导致少量误分类。但考虑到 Neutral 类在两类场景下的准确率均处于较高水平，且其他类别的提升幅度远超该类的轻微下降，这一取舍在整体上是有利的。

#imagex(
  image("figures/ablation/clahe/clahe_agreement_matrix.png", width: 70%),
  caption: [CLAHE 光照增强前后预测一致性矩阵],
  label-name: "img-clahe_agreement_matrix",
)

从预测一致性矩阵可以看出，使用 CLAHE 与不使用 CLAHE 的预测结果在多数类别上存在明显分歧，尤其是在 Sadness、Anger、Fear 等困难类别上，CLAHE 倾向于将原本被误判为 Neutral 的样本正确修正为真实标签，说明 CLAHE 有效纠正了因光照不足导致的特征混淆问题。

综合实验结果表明，CLAHE 光照增强能够：

- 提高图像局部对比度，增强关键区域纹理信息；
- 显著提升困难类别（Disgust、Contempt、Sadness）识别准确率；
- 提升模型预测置信度与决策稳定性；
- 有效纠正因光照不足导致的类别混淆；
- 增强模型在复杂光照环境下的鲁棒性。

因此，本文最终将 CLAHE 作为表情识别系统中的重要数据预处理模块。

=== 超分辨率重建实验

在人脸表情识别任务中，FERPlus 数据集原始图像分辨率仅为 $48 times 48$ 像素，图像细节信息严重匮乏，尤其是眼部、嘴角等关键区域纹理模糊，不利于模型提取细粒度表情特征。为提升输入图像质量，本文在数据预处理阶段采用超分辨率重建技术将图像缩放至 $224 times 224$ 像素，并对不同插值算法的效果进行系统评估。

实验中，本文分别对比了以下四种插值方法：

- NEAREST（最近邻插值）：直接取最近像素值，速度最快但易产生锯齿效应；
- LINEAR（双线性插值）：利用周围 $2 times 2$ 邻域像素进行线性加权，平滑效果较好但细节恢复有限；
- CUBIC（双三次插值）：利用 $4 times 4$ 邻域像素进行三次多项式拟合，能够较好地保留边缘与纹理信息；
- LANCZOS4（Lanczos 插值）：使用 $8 times 8$ 邻域进行 sinc 函数加权，理论上具有最优的频率响应特性。

四种方法在相同实验条件下进行对比实验，其余训练参数保持一致。

#imagex(
  image("figures/ablation/sr/sr_accuracy_bars.png", width: 80%),
  caption: [超分辨率重建插值方法总体准确率对比],
  label-name: "img-sr_accuracy_bars",
)

从实验结果可以看出，四种插值方法的总体准确率分别为：

- NEAREST：$73.71%$；
- LINEAR：$79.21%$；
- CUBIC：$81.31%$；
- LANCZOS4：$80.78%$。

其中 CUBIC 方法取得了最优的总体准确率，较 NEAREST 方法提升约 $7.54%$，较 LINEAR 方法提升约 $2.10%$。值得注意的是，LANCZOS4 方法虽然具有更宽的采样窗口，但准确率略低于 CUBIC，可能原因是 LANCZOS4 在 $48 times 48$ 极低分辨率情况下过度平滑导致部分高频细节损失。

#imagex(
  image("figures/ablation/sr/sr_accuracy_diff.png", width: 80%),
  caption: [超分辨率重建插值方法准确率差异对比（以 CUBIC 为基准）],
  label-name: "img-sr_accuracy_diff",
)

以 CUBIC 为基准的准确率差异图进一步表明，NEAREST 方法由于锯齿效应严重，准确率明显低于其他三种方法；LINEAR 方法在中低难度样本上与 CUBIC 的差距相对较小，但在困难样本上的表现仍不及 CUBIC。

此外，本文进一步统计了模型预测置信度分布情况，如图所示。

#imagex(
  image("figures/ablation/sr/sr_confidence_boxplot.png", width: 100%),
  caption: [超分辨率重建插值方法置信度分布对比],
  label-name: "img-sr_confidence_boxplot",
)

可以观察到：

-- CUBIC 方法平均置信度达到 $0.8275$；
-- LANCZOS4 方法平均置信度为 $0.8277$，与 CUBIC 基本持平；
-- LINEAR 方法平均置信度为 $0.8108$；
-- NEAREST 方法平均置信度仅为 $0.7745$。

CUBIC 与 LANCZOS4 在置信度方面表现相近且均显著优于 LINEAR 和 NEAREST，说明高阶插值方法能够产生更高质量的重建图像，使模型分类决策更加确信。

为了进一步分析不同插值方法对不同表情类别的影响，本文统计了各类别识别准确率，如图所示。

#imagex(
  image("figures/ablation/sr/sr_per_class_heatmap.png", width: 100%),
  caption: [超分辨率重建插值方法各类别准确率热力图],
  label-name: "img-sr_per_class_heatmap",
)

从各类别实验结果可以发现：

- Neutral 类：CUBIC 取得最高准确率 $83.22%$，较 NEAREST（$70.40%$）提升 $12.82%$；
- Happiness 类：LINEAR 取得最高准确率 $89.77%$，CUBIC 为 $89.10%$，两者表现接近；
- Surprise 类：CUBIC 取得最高准确率 $85.25%$；
- Sadness 类：NEAREST 意外取得最高准确率 $79.00%$，但 CUBIC（$69.45%$）与其他方法差距不大；
- Anger 类：LANCZOS4 取得最高准确率 $74.23%$，CUBIC 为 $73.93%$，两者接近；
- Disgust 类：CUBIC 与 LINEAR 均为 $50.00%$；
- Fear 类：CUBIC 取得最高准确率 $59.72%$；
- Contempt 类：LINEAR、CUBIC、LANCZOS4 均为 $29.63%$，NEAREST 仅为 $18.52%$。

综合来看，CUBIC 方法在 Neutral、Surprise、Fear 等多个类别上均取得最优性能，且在各类别间表现均衡，具有最佳的总体鲁棒性。

#imagex(
  image("figures/ablation/sr/sr_agreement_CUBIC_vs_NEAREST.png", width: 48%),
  image("figures/ablation/sr/sr_agreement_CUBIC_vs_LINEAR.png", width: 48%),
  caption: [CUBIC 与 NEAREST、LINEAR 方法预测一致性对比],
  label-name: "img-sr_agreement_1",
)

#imagex(
  image("figures/ablation/sr/sr_agreement_CUBIC_vs_LANCZOS4.png", width: 48%),
  caption: [CUBIC 与 LANCZOS4 方法预测一致性对比],
  label-name: "img-sr_agreement_2",
)

从不同插值方法之间的预测一致性矩阵可以看出：

-- CUBIC 与 LANCZOS4 之间具有最高的一致性，两者预测结果高度吻合，说明这两种高阶插值方法产生的图像特征高度相似；
-- CUBIC 与 LINEAR 之间一致性次之；
-- CUBIC 与 NEAREST 之间一致性最低，尤其在 Sadness、Anger 等类别上分歧明显，说明低质量重建会显著改变模型对困难样本的预测倾向。

综合实验结果表明：

- CUBIC 双三次插值在总体准确率、类别均衡性与置信度方面均表现最优；
- LANCZOS4 插值性能与 CUBIC 接近，但在极低分辨率场景下并无明显优势；
- LINEAR 方法性能居中，适合对推理速度有较高要求的场景；
- NEAREST 方法性能最差，不适用于表情识别任务中的超分辨率重建。

因此，本文最终选择 CUBIC（双三次插值）作为超分辨率重建的默认插值方法，以在图像质量与识别精度之间取得最佳平衡。

=== Dynamic Receptive Field Block 消融实验

为了验证本文提出的 Dynamic Receptive Field Block 对模型性能的实际贡献，本文在 MobileNetV3Small 基础上分别对标准模型与引入动态感受野模块后的改进模型进行了对比实验。两组实验采用完全相同的数据预处理流程与训练参数配置，唯一的变量为是否将网络中部分 Depthwise Convolution 替换为 Dynamic Receptive Field Block。

#imagex(
  subimagex(
    image("figures/ablation/drf/drf_accuracy_bars.png", width: 100%),
    caption: [总体准确率对比],
    label-name: "img-drf_accuracy_bars",
  ),
  subimagex(
    image("figures/ablation/drf/drf_model_size.png", width: 85%),
    caption: [实验参数量对比],
    label-name: "img-drf_model_size",
  ),
  columns: 2,
  caption: [准确率与参数量对比],
  label-name: "img-drf-acc-size",
  placement: none, 
)

从实验结果可以看出：

- 标准 MobileNetV3Small 总体准确率为 $78.63%$；
- Dynamic-MobileNetV3Small 总体准确率为 $81.31%$；
- 引入 Dynamic Receptive Field Block 后准确率提升 $2.68$ 个百分点。

说明动态感受野机制能够有效增强模型对多尺度表情特征的提取能力，从而提升整体识别性能。

在参数量方面：

- 标准 MobileNetV3Small 参数量为 $1.5261$M；
- Dynamic-MobileNetV3Small 参数量为 $1.2265$M；
- 参数量减少约 $0.2996$M，降幅达 $19.6%$。

这一结果具有重要意义：Dynamic Receptive Field Block 在提升准确率的同时，反而降低了模型参数量。其原因在于，动态感受野模块采用并行的 $3 times 3$ 与 $5 times 5$ Depthwise Convolution 替代了原网络中部分标准卷积结构，Depthwise Convolution 本身具有更低的参数开销，且自适应权重融合机制仅引入极少量的全连接层参数，因此整体参数量不增反降。这说明本文提出的模块在"轻量化—准确率"的权衡中实现了双赢。

此外，本文进一步统计了模型预测置信度分布情况，如图所示。

#imagex(
  image("figures/ablation/drf/drf_confidence_distribution.png", width: 100%),
  caption: [Dynamic Receptive Field Block 消融实验置信度分布对比],
  label-name: "img-drf_confidence_distribution",
)

可以观察到：

-- Dynamic-MobileNetV3Small 平均置信度达到 $0.8275$；
-- 标准 MobileNetV3Small 平均置信度仅为 $0.6542$，提升幅度高达 $0.1733$。

置信度的大幅提升是 Dynamic Receptive Field Block 最显著的效果之一。标准 MobileNetV3Small 由于感受野固定，在面对复杂表情时容易产生犹豫不决的预测，导致大量样本置信度集中在中等区间。而动态感受野机制能够根据输入特征自适应选择最优感受野范围，使模型分类决策更加果断。

#imagex(
  image("figures/ablation/drf/drf_confidence_scatter.png", width: 70%),
  caption: [Dynamic Receptive Field Block 消融实验置信度散点分布对比],
  label-name: "img-drf_confidence_scatter",
)

从置信度散点图可以更直观地看出，Dynamic-MobileNetV3Small 的样本置信度整体向高值区间偏移，大量原本置信度低于 $0.6$ 的样本在新模型中被提升至 $0.8$ 以上，说明动态感受野显著增强了模型预测的确定性。

为了进一步分析 Dynamic Receptive Field Block 对不同表情类别的影响，本文统计了各类别识别准确率，如图所示。

#imagex(
  image("figures/ablation/drf/drf_per_class_accuracy.png", width: 100%),
  caption: [Dynamic Receptive Field Block 消融实验各类别准确率对比],
  label-name: "img-drf_per_class_accuracy",
)

从各类别实验结果可以发现：

- Surprise：$80.26% → 85.25%$（$+4.99%$）；
- Sadness：$53.70% → 69.45%$（$+15.75%$）；
- Anger：$64.11% → 73.93%$（$+9.82%$）；
- Disgust：$44.12% → 50.00%$（$+5.88%$）；
- Contempt：$14.81% → 29.63%$（$+14.81%$）；
- Neutral：$84.56% → 83.22%$（$-1.34%$）；
- Happiness：$90.32% → 89.10%$（$-1.22%$）；
- Fear：$62.50% → 59.72%$（$-2.78%$）。

Dynamic Receptive Field Block 对中等及困难类别具有明显的提升效果：

- Sadness 类提升最为显著（$+15.75%$），从 $53.70%$ 大幅提升至 $69.45%$，说明动态多尺度感受野能够更好地捕捉悲伤表情中涉及的眼部、嘴角等区域的细节变化；
- Contempt 类提升 $14.81%$，该类样本数量稀少且表情特征微妙，固定感受野难以有效建模，而动态感受野的自适应能力使其识别率接近翻倍；
- Anger 类提升 $9.82%$，表明多尺度特征有助于区分愤怒与厌恶等易混淆表情。

与此同时，Neutral、Happiness 与 Fear 三类出现轻微下降。这些类别在标准模型中已经处于较高准确率水平，动态感受野带来的特征空间调整可能导致少量边界样本的类别归属发生变化。但考虑到下降幅度均在 $3%$ 以内，且困难类别提升幅度远超这一轻微损失，整体上动态感受野模块的增益是十分显著的。

#imagex(
  image("figures/ablation/drf/drf_agreement_matrix.png", width: 70%),
  caption: [Dynamic Receptive Field Block 消融实验预测一致性矩阵],
  label-name: "img-drf_agreement_matrix",
)

从预测一致性矩阵可以看出，标准模型与动态模型在 Sadness、Anger、Contempt 等类别上存在较大分歧。动态模型倾向于将标准模型误判为 Neutral 或 Happiness 的困难样本修正为正确的真实标签，印证了动态感受野机制在复杂表情识别中的有效性。

综合实验结果表明，Dynamic Receptive Field Block 能够：

- 提升模型总体准确率 $2.68$ 个百分点，同时降低参数量 $19.6%$；
- 大幅提升模型预测置信度（$+0.1733$），增强分类决策确定性；
- 显著改善困难类别识别性能，尤其是 Sadness（$+15.75%$）与 Contempt（$+14.81%$）；
- 通过多尺度并行卷积与自适应权重融合，实现"准确率-效率"双赢。

因此，本文提出的 Dynamic Receptive Field Block 是提升轻量化表情识别模型性能的有效设计方案。

== 实验结果分析

通过前述模型对比实验与消融实验，本文从总体准确率、参数量与 FLOPs、F1-Score、置信度分布以及各类别细粒度表现等多个维度对所提出的 Dynamic-MobileNetV3Small 进行了全面评估。以下从四个角度对实验结果进行深入分析。

=== Dynamic-MobileNetV3Small 性能分析

在全部参与对比的七种模型中，本文提出的 Dynamic-MobileNetV3Small 在 FerPlus 数据集上取得了最优的总体性能：

- 总体准确率 $82.73%$，为所有模型中最高；
- F1-Score $82.24%$，同样位列第一；
- 模型大小仅 $1.23"MB"$，为所有模型中最小；
- 计算量仅 $0.05"GFLOPs"$，为所有模型中最低。

与原始 MobileNetV3Small 相比，Dynamic-MobileNetV3Small 在准确率上提升 $1.50$ 个百分点，F1-Score 提升 $2.21$ 个百分点，同时模型大小减少 $0.30"MB"$（降幅 $19.6%$），计算量降低 $0.01"GFLOPs"$。这表明引入动态感受野模块不仅在识别性能上带来了实质性增益，还通过 Depthwise Convolution 的参数效率优势进一步压缩了模型规模。

消融实验数据进一步揭示，Dynamic Receptive Field Block 对模型置信度的提升尤为突出——平均置信度从 $0.6542$ 提升至 $0.8275$，增幅 $0.1733$（$+26.5%$）。置信度的大幅跃升说明动态感受野机制使模型从"犹豫不决"转变为"果断决策"，这一特性对实际部署中的可靠性至关重要：高置信度的正确预测意味着模型在真实场景中更不容易产生模棱两可的输出，从而降低误判风险。

在各类别表现方面，Dynamic-MobileNetV3Small 在 Surprise（$85.25%$）、Sadness（$69.45%$）、Anger（$73.93%$）等中等难度类别上相较标准 MobileNetV3Small 均取得了显著提升。尤其是 Sadness 类从 $53.70%$ 提升至 $69.45%$（$+15.75$ 个百分点），表明动态感受野对涉及大面积面部肌肉变化的复杂表情具有更强的建模能力。

=== 多尺度特征提取效果分析

本文提出的 Dynamic Receptive Field Block 核心创新在于通过并行 $3 times 3$ 与 $5 times 5$ Depthwise Convolution 实现多尺度特征提取，并利用自适应权重融合机制动态调整不同感受野的重要性。消融实验结果充分验证了该设计的有效性。

从感受野角度分析，不同表情类别对感受野的需求存在显著差异：

- 小尺度感受野（$3 times 3$）：适合捕捉局部细节变化，如嘴角微扬（Happiness）、眉头轻皱（Sadness）等精细肌肉运动；
- 大尺度感受野（$5 times 5$）：适合感知更广泛的面部区域变化，如惊讶时嘴巴张开与眉毛抬升的协同运动（Surprise）、愤怒时整体面部肌肉的紧张状态（Anger）。

固定卷积核结构（如标准 MobileNetV3Small）无法针对不同输入样本动态调整感受野偏好，因此在面对特征尺度差异较大的表情类别时表现受限。Dynamic Receptive Field Block 通过 Softmax 加权机制，使模型能够根据输入图像的内容自适应地分配注意力权重——对于局部特征主导的表情，$3 times 3$ 分支获得更高权重；对于全局特征主导的表情，$5 times 5$ 分支获得更高权重。

实验数据有力地支撑了这一分析：

- Surprise 类准确率从 $80.26%$ 提升至 $85.25%$（$+4.99%$），该类表情通常涉及较大范围的面部变化，多尺度特征融合能够同时捕捉嘴部、眼部及眉部的协同运动；
- Sadness 类提升 $15.75$ 个百分点，该类表情的特征分布于眼部（下垂）、嘴角（下撇）及眉部（内倾）等多个局部区域，多尺度并行结构有效整合了这些分散的判别信息；
- Anger 类提升 $9.82$ 个百分点，表明多尺度感受野有助于区分愤怒与厌恶等在外观上相近但感受野需求不同的易混淆表情。

值得注意的是，引入多尺度特征提取后，Neutral、Happiness 与 Fear 三类出现了轻微波动（下降幅度均小于 $3%$）。这些类别在标准模型中已达到较高准确率（$84%$ 以上），其特征表达相对充分，动态感受野的引入可能使特征空间中的类别边界发生微调，从而导致少量边界样本的重新分配。由于困难类别的提升幅度远超这一微小代价，整体上多尺度特征提取机制带来的收益是十分显著的。

=== 轻量化与准确率平衡分析

轻量化神经网络的核心挑战在于在模型规模与识别性能之间取得最优平衡。本节从"准确率—模型大小"与"准确率—计算量"两个维度综合评估各模型的效率表现。

从模型规模角度对比：

- ResNet18 以 $11.18"MB"$ 的模型体积仅取得 $74.23%$ 准确率，效率比（Accuracy / Size）为 $6.64% / "MB"$；
- ResNet-Transformer 体积为 $11.99"MB"$，准确率 $78.54%$，效率比为 $6.55% / "MB"$；
- MobileNetV3Small 体积为 $1.53"MB"$，准确率 $81.23%$，效率比高达 $53.09% / "MB"$，约为 ResNet18 的 $8$ 倍；
- Dynamic-MobileNetV3Small 体积进一步压缩至 $1.23"MB"$，准确率提升至 $82.73%$，效率比达到 $67.26% / "MB"$，为 ResNet18 的 $10$ 倍以上。

从计算复杂度角度对比：

- ResNet-Transformer 的 GFLOPs 高达 $28.43$，是 Dynamic-MobileNetV3Small（$0.05"GFLOPs"$）的约 $569$ 倍，但准确率反而低 $4.19$ 个百分点；
- MobileNetV3Small 计算量为 $0.06"GFLOPs"$，Dynamic-MobileNetV3Small 进一步降至 $0.05"GFLOPs"$，在接近极限的低计算量下仍然实现了准确率提升。

上述对比表明，本文提出的 Dynamic-MobileNetV3Small 成功打破了传统"高准确率必然伴随高计算代价"的固有认知。其轻量化优势来源于三个层次的设计：

1. Backbone 选择：采用 MobileNetV3Small 作为基础网络，利用其深度可分离卷积与 SE 模块在参数效率上的固有优势；
2. 模块轻量化设计：Dynamic Receptive Field Block 使用并行 Depthwise Convolution 替代部分标准卷积，Depthwise Conv 的参数量仅为标准卷积的 $1 / C_"out"$，显著降低了参数开销；
3. 融合机制极简化：自适应权重生成仅通过全局平均池化与单层全连接实现，引入的额外参数量几乎可忽略不计。

综合来看，Dynamic-MobileNetV3Small 以最小的模型体积（$1.23"MB"$）和最低的计算量（$0.05"GFLOPs"$）取得了最高的准确率（$82.73%$）与 F1-Score（$82.24%$），在轻量化与准确率的帕累托前沿上占据了最优位置。

=== 模型优势与不足

综合全部实验结果，本文提出的 Dynamic-MobileNetV3Small 具有以下显著优势：

（1）极致的轻量化特性。 模型大小仅 $1.23"MB"$，计算量仅 $0.05"GFLOPs"$，在所有对比模型中均为最低。如此轻量的模型可轻松部署于移动端、嵌入式设备及边缘计算节点，满足实时表情识别的工程需求。

（2）优异的识别性能。 在 FerPlus 数据集上取得 $82.73%$ 的总体准确率与 $82.24%$ 的 F1-Score，超越 ResNet18（$74.23%$）、ResNet-Transformer（$78.54%$）以及原始 MobileNetV3Small（$81.23%$）等全部对比模型。

（3）动态多尺度感受野机制。 Dynamic Receptive Field Block 通过并行多尺度卷积与自适应权重融合，使模型能够根据输入样本的表情特征动态选择最优感受野范围。这一机制在 Sadness（$+15.75%$）、Contempt（$+14.81%$）等困难类别上的提升尤为突出，充分证明了其有效性。

（4）高置信度决策能力。 动态感受野的引入使模型平均置信度从 $0.6542$ 跃升至 $0.8275$，大幅增强了预测的确定性与可靠性，有利于在实际应用中减少因低置信度导致的拒识或误判。

（5）良好的数据预处理兼容性。 实验表明，CLAHE 光照增强与 CUBIC 超分辨率重建两项预处理技术对模型性能有显著促进作用。Dynamic-MobileNetV3Small 与这套预处理流程形成了良好的协同效应，共同构成了完整的轻量化表情识别系统。

与此同时，本文模型仍存在以下不足与改进空间：

（1）困难类别识别率仍有提升空间。 尽管 Contempt、Disgust 与 Fear 三类在动态感受野的帮助下已有明显改善，但 Contempt（$29.63%$）、Disgust（$50.00%$）与 Fear（$59.72%$）的绝对准确率仍然偏低。主要原因是这些类别在数据集中样本量稀少（尤其是 Contempt 与 Disgust），模型难以充分学习其判别特征。后续可考虑引入数据增强、代价敏感学习或少样本学习策略进一步改善。

（2）Neutral 类准确率的轻微下降。 在 CLAHE 增强与动态感受野两个消融实验中，Neutral 类准确率均出现了小幅下降（分别下降 $5.22%$ 与 $1.34%$）。虽然 Neutral 类准确率仍维持在 $83%$ 以上的较高水平，但这一现象的持续出现值得关注。可能的原因是 CLAHE 增强放大了 Neutral 样本中原本不显著的纹理细节，使部分 Neutral 样本与弱强度表情产生特征混淆。未来可探索针对 Neutral 类的专项优化策略。

（3）动态权重的可解释性有待深入。 虽然自适应权重融合机制在实验中展现出良好效果，但目前尚未对权重分布与表情类别之间的关系进行系统性的可视化分析。理解不同表情类别对应的感受野偏好模式，有助于进一步优化模块设计并为表情识别提供更有价值的洞察。

（4）跨数据集泛化能力有待进一步验证。 本文主要基于 FerPlus 数据集进行实验验证，虽然模型对比实验中也纳入了 RAF-DB 数据集的部分结果，但尚未系统性地评估模型在更多样化场景（如不同光照条件、不同拍摄角度、不同分辨率）下的泛化表现。后续可在更大规模、多场景的数据集上进行验证与微调。

= 总结与展望

== 本文工作总结

本文围绕"轻量化神经网络的表情识别系统"这一核心目标，从数据预处理、模型设计与实验验证三个层面开展了系统性研究，取得了以下主要成果。

=== 数据预处理工作总结

针对 FerPlus 与 RAF-DB 数据集中存在的图像分辨率低、光照条件复杂等问题，本文构建了一套完整的数据预处理流程：

（1）超分辨率重建。 将 FerPlus 数据集原始 $48 times 48$ 低分辨率图像统一重建至 $224 times 224$，并通过对比 NEAREST、LINEAR、CUBIC、LANCZOS4 四种插值方法，确定 CUBIC 双三次插值为最优方案，总体准确率达 $81.31%$。

（2）CLAHE 光照增强。 引入限制对比度自适应直方图均衡化技术，有效改善了光照不均与局部对比度不足问题。消融实验表明，加入 CLAHE 后准确率从 $67.39%$ 提升至 $81.31%$（$+13.92$ 个百分点），Disgust 与 Contempt 等极端困难类别获得了显著改善。

（3）数据增强策略。 在训练阶段采用随机翻转、随机裁剪与随机旋转等在线增强方法，有效扩充了训练数据多样性，缓解了过拟合风险。

=== 模型设计工作总结

本文以 MobileNetV3Small 为 Backbone，设计并实现了一种 Dynamic-MobileNetV3Small 轻量化表情识别模型，核心工作包括：

（1）Backbone 选型与对比。 对 ResNet18、ResNet18+CBAM、ResNet18+ViT、MobileNetV1、MobileNetV2 及 MobileNetV3Small 六种模型进行了系统实验对比，分析了各模型在准确率、参数量、FLOPs 和 F1-Score 上的综合表现，最终选择 MobileNetV3Small 作为基础网络。

（2）Dynamic Receptive Field Block 设计。 提出了一种动态感受野模块，通过并行 $3 times 3$ 与 $5 times 5$ Depthwise Convolution 提取多尺度表情特征，并利用全局平均池化与 Softmax 机制生成自适应融合权重，使模型能够根据输入表情动态调整感受野偏好。

（3）轻量化结构优化。 在引入动态感受野机制的同时，利用 Depthwise Convolution 的参数效率优势，使模型参数量从 $1.5261"M"$ 降至 $1.2265"M"$（降幅 $19.6%$），实现了性能提升与模型压缩的双赢。

=== 实验结果总结

通过全面的模型对比实验与消融实验，对所提出的 Dynamic-MobileNetV3Small 进行了系统性验证：

（1）总体性能。 Dynamic-MobileNetV3Small 在 FerPlus 数据集上取得 $82.73%$ 准确率与 $82.24%$ F1-Score，超越全部对比模型，同时模型大小（$1.23"MB"$）与计算量（$0.05"GFLOPs"$）均为最低。

（2）消融验证。 CLAHE 光照增强实验（$+13.92%$）、超分辨率重建实验（CUBIC 最优 $81.31%$）和 DRF 消融实验（$+2.68%$，参数量 $-19.6%$）分别验证了各模块的有效性。

（3）置信度提升。 动态感受野机制使模型平均置信度从 $0.6542$ 提升至 $0.8275$（$+26.5%$），大幅增强了模型预测的确定性与可靠性。

（4）困难类别改善。 Sadness（$+15.75%$）、Contempt（$+14.81%$）与 Anger（$+9.82%$）等类别在动态感受野的帮助下取得了显著提升。

== 本文创新点总结

=== 动态感受野模块创新

本文提出了一种 Dynamic Receptive Field Block，通过并行 $3 times 3$ 与 $5 times 5$ Depthwise Convolution 构建多尺度特征提取分支，并引入自适应权重融合机制，使模型能够根据输入表情的尺度特征动态调整不同感受野的重要性。与固定卷积核的传统方法相比，该模块使模型能够针对不同表情类别灵活选择最优感受野范围，在 Sadness、Contempt 等复杂表情上取得了显著提升。

=== 轻量化结构优化

本文在 MobileNetV3Small 基础上，利用 Depthwise Convolution 的参数效率优势实现了动态感受野模块的轻量化设计。实验结果表明，引入动态感受野机制后模型参数量不增反降（$-19.6%$），以 $1.23"MB"$ 的最小模型体积取得了 $82.73%$ 的最高准确率，效率比达到 ResNet18 的 $10$ 倍以上，为轻量化表情识别模型的"准确率—效率"平衡提供了有效方案。

=== 多尺度特征融合创新

本文通过并行多尺度卷积与 Softmax 自适应权重的组合设计，实现了对局部细节特征与全局上下文特征的动态融合。该机制避免了传统方法中感受野固定导致的特征尺度不匹配问题，使模型能够同时关注嘴角、眼部等局部纹理信息以及面部整体肌肉运动等全局结构信息，从而更全面地捕捉不同表情类别之间的差异性特征。

== 不足与未来展望

=== 当前模型存在的问题

尽管本文提出的 Dynamic-MobileNetV3Small 在多个维度上取得了优异表现，但仍存在以下问题：

（1）Contempt（$29.63%$）、Disgust（$50.00%$）与 Fear（$59.72%$）等困难类别的绝对准确率仍然偏低，主要受限于数据集中这些类别的样本数量稀少；

（2）Neutral 类在 CLAHE 增强与动态感受野引入后均出现了轻微下降，特征空间边界偏移问题需要进一步关注；

（3）自适应权重融合机制的可解释性分析尚不充分，尚未对不同表情类别对应的感受野偏好模式进行可视化研究。

=== 后续优化方向

针对上述问题，后续研究可从以下方向展开：

（1）数据层面。 引入代价敏感学习、Focal Loss 或数据重采样策略，有针对性地提升少样本类别的识别性能；探索生成式数据增强（如 GAN-based augmentation）为困难类别扩充训练样本。

（2）模型层面。 进一步优化动态感受野结构，探索引入更多尺度分支（如 $7 times 7$）或可变形卷积以增强感受野灵活性；研究权重分布与表情类别之间的对应关系，提升模块可解释性。

（3）系统层面。 将模型部署至实际移动端设备（如手机、嵌入式开发板）进行实测，评估真实场景下的推理延迟、功耗与内存占用；探索模型量化、剪枝与知识蒸馏等进一步压缩手段。

=== 表情识别未来研究趋势

结合本文研究工作与当前领域发展动态，人脸表情识别未来可能在以下方向取得突破：

（1）多模态融合。 融合面部表情、语音语调、生理信号与姿态信息等多模态数据，构建更加鲁棒的情感计算系统。

（2）自监督与少样本学习。 利用自监督预训练方法从大规模无标注人脸数据中学习通用表情表征，降低对标注数据的依赖，缓解少样本类别的学习困难。

（3）连续维度情感识别。 从离散类别分类扩展到 Valence-Arousal 连续维度情感空间建模，实现更加精细的情感状态估计。

（4）隐私保护与边缘智能。 在数据安全法规日益严格的背景下，研究联邦学习与边缘推理相结合的表情识别方案，实现数据不出设备的隐私保护型情感计算。

（5）动态时序表情分析。 从静态图像识别扩展到视频序列中的动态表情变化分析，捕捉表情从起始到峰值的完整演变过程，提升自然场景下的识别鲁棒性。

// 显示结论
#conclusion[
  本文围绕轻量化表情识别这一核心任务，设计并实现了一种基于动态感受野机制的 Dynamic-MobileNetV3Small 模型。通过在 MobileNetV3Small 基础网络中引入并行多尺度 Depthwise Convolution 与自适应权重融合机制，模型能够根据输入表情特征动态调整感受野范围，有效提升了多尺度表情特征的提取能力。

  实验结果表明，本文提出的模型在 FerPlus 数据集上以 $1.23"MB"$ 的最小模型体积和 $0.05"GFLOPs"$ 的最低计算量，取得了 $82.73%$ 的最高准确率与 $82.24%$ 的最高 F1-Score，在轻量化与识别性能之间实现了最优平衡。CLAHE 光照增强与 CUBIC 超分辨率重建两项预处理技术的有效性也得到了充分验证。

  本文的研究成果为移动端与边缘设备上的实时表情识别提供了一套完整的轻量化解决方案，所提出的动态感受野设计思路对轻量化视觉模型的架构优化具有一定的参考价值。
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
