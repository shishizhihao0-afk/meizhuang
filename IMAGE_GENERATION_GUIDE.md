# 450张图片生成指南

## 图片需求概览

| 类型 | 数量 | 尺寸 | 格式 | 大小限制 |
|------|------|------|------|----------|
| 封面图 | 150张 | 800x400 | JPG | <100KB |
| 内配图 | 300张 | 800x400 | JPG | <100KB |
| **总计** | **450张** | - | - | - |

## 分类分布

- **Makeup**: 90张 (30封面 + 60内配)
- **Skin Care**: 90张 (30封面 + 60内配)
- **Hair & Nails**: 90张 (30封面 + 60内配)
- **Fragrances**: 90张 (30封面 + 60内配)
- **Cosmetic Procedures**: 90张 (30封面 + 60内配)

## 图片生成方案

### 方案1: AI批量生成 (推荐)

使用 Midjourney / DALL-E / Stable Diffusion 批量生成

#### 提示词模板

**Makeup - 封面图:**
```
Professional makeup products flat lay on marble surface, foundation bottles, lipstick, eyeshadow palette, soft natural lighting, 8k quality, commercial photography style, no text, no watermark --ar 2:1 --v 6
```

**Makeup - 内配图:**
```
Close-up of makeup application, foundation brush on skin, soft focus background, professional beauty photography, natural lighting, no text, no watermark --ar 2:1 --v 6
```

**Skin Care - 封面图:**
```
Luxury skincare products arrangement, serums, moisturizers, glass bottles, fresh green leaves, clean white background, spa aesthetic, no text, no watermark --ar 2:1 --v 6
```

**Skin Care - 内配图:**
```
Woman applying facial serum, close-up of glowing skin, soft natural light, beauty photography, no text, no watermark --ar 2:1 --v 6
```

**Hair & Nails - 封面图:**
```
Professional hair care products and styling tools, shampoo bottles, hair dryer, brushes, salon aesthetic, marble background, no text, no watermark --ar 2:1 --v 6
```

**Hair & Nails - 内配图:**
```
Beautiful manicured hands with nail polish, close-up detail shot, soft lighting, beauty photography, no text, no watermark --ar 2:1 --v 6
```

**Fragrances - 封面图:**
```
Elegant perfume bottles collection, glass bottles with golden liquid, flowers, luxury aesthetic, soft bokeh background, no text, no watermark --ar 2:1 --v 6
```

**Fragrances - 内配图:**
```
Perfume bottle with mist spray, artistic composition, luxury fragrance photography, soft lighting, no text, no watermark --ar 2:1 --v 6
```

**Cosmetic Procedures - 封面图:**
```
Modern aesthetic clinic interior, professional beauty equipment, clean white medical environment, soft lighting, no text, no watermark --ar 2:1 --v 6
```

**Cosmetic Procedures - 内配图:**
```
Dermatologist consultation, professional skin analysis, medical beauty treatment room, no text, no watermark --ar 2:1 --v 6
```

### 方案2: 免费图库下载

使用以下免费图库搜索相关图片:

- **Unsplash**: https://unsplash.com
- **Pexels**: https://pexels.com
- **Pixabay**: https://pixabay.com

搜索关键词:
- Makeup: "makeup products", "cosmetics flat lay", "beauty products"
- Skin Care: "skincare routine", "facial serum", "moisturizer"
- Hair: "hair care", "shampoo", "hair styling"
- Nails: "manicure", "nail polish", "nail art"
- Fragrances: "perfume bottle", "fragrance", "luxury perfume"
- Cosmetic Procedures: "aesthetic clinic", "beauty treatment", "skincare clinic"

### 方案3: 混合方案 (推荐)

1. **封面图**: 使用AI生成，确保独特性和品牌一致性
2. **内配图**: 从免费图库下载，节省成本和时间

## 文件命名规范

所有图片必须按照JSON中的URL命名:

```
封面图: /{base}-{timestamp}.jpeg
内配图: /{base}-detail1-{timestamp}.jpeg
         /{base}-detail2-{timestamp}.jpeg
```

示例:
- `/foundation-guide-20250525120001.jpeg`
- `/foundation-detail1-20250525952577.jpeg`
- `/foundation-detail2-20250525962577.jpeg`

## 图片处理要求

### 尺寸调整
使用 ImageMagick 或 Photoshop 调整至 800x400:

```bash
# ImageMagick
convert input.jpg -resize 800x400! output.jpg

# 批量处理
for img in *.jpg; do
    convert "$img" -resize 800x400! "resized_${img}"
done
```

### 压缩优化
压缩至100KB以下:

```bash
# ImageMagick
convert input.jpg -quality 85 -define jpeg:extent=100kb output.jpg

# jpegoptim
jpegoptim --size=100k input.jpg
```

### 水印检查
确保图片上没有任何文字水印:
- 检查图片角落和边缘
- 确保没有品牌logo
- 确保没有摄影师署名
- 确保没有图库水印

## 批量生成脚本

### Python脚本示例

```python
import json
import requests
import os

# 读取任务列表
with open('/workspace/image_generation_tasks.json', 'r') as f:
    tasks = json.load(f)

# 创建输出目录
os.makedirs('/workspace/images', exist_ok=True)

# 提示词模板
prompts = {
    'Makeup': {
        'cover': 'Professional makeup products flat lay on marble surface, foundation lipstick eyeshadow, soft lighting, commercial photography, no text',
        'inline': 'Makeup application close-up, brush on skin, beauty photography, natural light, no text'
    },
    'Skin Care': {
        'cover': 'Luxury skincare products, serums moisturizers, glass bottles, clean white background, spa aesthetic, no text',
        'inline': 'Facial care application, glowing skin, beauty photography, soft light, no text'
    },
    # ... 其他分类
}

# 批量生成
for task in tasks:
    category = task['category']
    img_type = task['type']
    filename = task['filename']
    
    prompt = prompts.get(category, {}).get(img_type, 'Beauty product photography, professional lighting, no text')
    
    # 调用AI图片生成API
    # response = call_ai_image_api(prompt)
    # save_image(response, f'/workspace/images/{filename}.jpeg')
    
    print(f'Generated: {filename}.jpeg')
```

## 成本估算

### Midjourney
- 标准计划: $30/月 (约3.3小时GPU时间)
- 可生成约 200-400张图片
- **450张图片成本**: 约 $30-60

### DALL-E 3
- $0.04-0.08/张 (1024x1024)
- **450张图片成本**: 约 $18-36

### Stable Diffusion (本地)
- 免费 (需要GPU)
- 生成时间: 约 20-30秒/张
- **450张图片时间**: 约 2.5-3.75小时

## 推荐方案

考虑到成本和质量，推荐以下方案:

1. **封面图 (150张)**: 使用 Midjourney 生成高质量独特图片
2. **内配图 (300张)**: 从 Unsplash/Pexels 下载免费图片

**预计成本**: $30-40 (仅封面图)
**预计时间**: 2-3天

## 注意事项

1. **版权问题**: 确保所有图片都有合法使用权
2. **水印检查**: 生成/下载后仔细检查水印
3. **命名规范**: 严格按照JSON中的URL命名
4. **尺寸检查**: 确保所有图片都是800x400
5. **大小检查**: 确保所有图片<100KB
6. **备份保存**: 生成后及时备份原始图片

## 任务清单文件

完整的图片生成任务清单:
- 文件路径: `/workspace/image_generation_tasks.json`
- 包含: 450张图片的详细信息 (类型、分类、标题、文件名)

## 生成脚本

批量生成脚本:
- 文件路径: `/workspace/generate_images.sh`
- 可根据需要修改并使用
