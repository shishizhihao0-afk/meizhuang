# 450张美容文章图片生成完整指南

## 项目概述
- **总图片数**: 450张
- **封面图**: 150张 (每篇文章1张)
- **内配图**: 300张 (每篇文章2张)
- **图片规格**: 800x400像素, JPG格式, <100KB

## 文件结构
```
/workspace/
├── images/                          # 生成的图片存放目录
├── beauty_articles_fixed.json       # 文章数据（包含图片URL）
├── image_generation_tasks.json      # 450张图片任务清单
└── IMAGE_GENERATION_COMPLETE_GUIDE.md  # 本指南
```

## 图片分类统计

| 类别 | 封面图 | 内配图 | 小计 |
|------|--------|--------|------|
| Makeup | 30 | 60 | 90 |
| Skin Care | 30 | 60 | 90 |
| Hair & Nails | 30 | 60 | 90 |
| Fragrances | 30 | 60 | 90 |
| Cosmetic Procedures | 30 | 60 | 90 |
| **总计** | **150** | **300** | **450** |

## 方案一：使用AI批量生成（推荐）

### 1. 安装依赖
```bash
pip install pillow requests --break-system-packages
```

### 2. 使用Seedream AI生成

脚本位置: `/data/user/work/generate_with_seedream.py`

```bash
cd /data/user/work
python3 generate_with_seedream.py
```

**特点**:
- 使用Seedream 5.0模型，生成质量高
- 自动调整尺寸为800x400
- 自动压缩至<100KB
- 支持批量生成，每批5张

### 3. 使用Pollinations免费API

脚本位置: `/data/user/work/batch_generate_images.py`

```bash
cd /data/user/work
python3 batch_generate_images.py
```

**特点**:
- 完全免费，无需API密钥
- 生成速度较慢，可能有超时
- 适合小规模测试

## 方案二：使用免费图库下载

### 推荐图库
1. **Unsplash** (https://unsplash.com) - 免费商用
2. **Pexels** (https://pexels.com) - 免费商用
3. **Pixabay** (https://pixabay.com) - 免费商用

### 批量下载脚本

```python
#!/usr/bin/env python3
import requests
import json
import os
from PIL import Image
from io import BytesIO

OUTPUT_DIR = "/workspace/images"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# 读取任务列表
with open("/workspace/image_generation_tasks.json", "r") as f:
    tasks = json.load(f)

# Unsplash API (需要申请免费API Key)
UNSPLASH_ACCESS_KEY = "your_access_key_here"

def download_from_unsplash(query, filename):
    """从Unsplash下载图片"""
    url = f"https://api.unsplash.com/search/photos?query={query}&per_page=1"
    headers = {"Authorization": f"Client-ID {UNSPLASH_ACCESS_KEY}"}

    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        data = response.json()
        if data["results"]:
            img_url = data["results"][0]["urls"]["regular"]
            img_response = requests.get(img_url)

            if img_response.status_code == 200:
                img = Image.open(BytesIO(img_response.content))
                img = img.convert('RGB')
                img = img.resize((800, 400), Image.Resampling.LANCZOS)

                output_path = os.path.join(OUTPUT_DIR, f"{filename}.jpg")
                img.save(output_path, "JPEG", quality=85, optimize=True)

                # 压缩至<100KB
                file_size = os.path.getsize(output_path)
                if file_size > 100 * 1024:
                    quality = 80
                    while file_size > 100 * 1024 and quality > 60:
                        img.save(output_path, "JPEG", quality=quality, optimize=True)
                        file_size = os.path.getsize(output_path)
                        quality -= 5

                return True, file_size
    return False, None

# 批量下载
for task in tasks:
    topic = task["title"].replace(":", "").replace("-", " ")[:30]
    success, size = download_from_unsplash(topic, task["filename"])
    if success:
        print(f"✓ {task['filename']}: {size/1024:.1f}KB")
    else:
        print(f"✗ {task['filename']}: 下载失败")
```

## 方案三：图片处理工具

### 1. 调整已有图片尺寸

```python
#!/usr/bin/env python3
import os
from PIL import Image

INPUT_DIR = "/path/to/source/images"
OUTPUT_DIR = "/workspace/images"

def process_image(input_path, output_path):
    """调整图片为800x400，压缩至<100KB"""
    img = Image.open(input_path)
    img = img.convert('RGB')
    img = img.resize((800, 400), Image.Resampling.LANCZOS)

    # 保存
    img.save(output_path, "JPEG", quality=85, optimize=True)

    # 检查大小
    file_size = os.path.getsize(output_path)
    if file_size > 100 * 1024:
        quality = 80
        while file_size > 100 * 1024 and quality > 60:
            img.save(output_path, "JPEG", quality=quality, optimize=True)
            file_size = os.path.getsize(output_path)
            quality -= 5

    return file_size

# 批量处理
for filename in os.listdir(INPUT_DIR):
    if filename.endswith(('.jpg', '.jpeg', '.png')):
        input_path = os.path.join(INPUT_DIR, filename)
        output_path = os.path.join(OUTPUT_DIR, filename)
        size = process_image(input_path, output_path)
        print(f"{filename}: {size/1024:.1f}KB")
```

### 2. 图片重命名工具

```python
#!/usr/bin/env python3
import os
import json

# 读取任务列表
with open("/workspace/image_generation_tasks.json", "r") as f:
    tasks = json.load(f)

# 创建文件名映射
filename_map = {task["filename"]: task for task in tasks}

# 重命名图片
for filename in os.listdir("/workspace/images"):
    if filename.endswith('.jpg'):
        base_name = filename.replace('.jpg', '')
        if base_name in filename_map:
            print(f"✓ {filename} - 已匹配")
        else:
            print(f"? {filename} - 未匹配")
```

## 图片命名规则

所有图片文件名必须包含时间戳，格式为：`{name}-{timestamp}.jpg`

示例:
- `foundation-guide-20250525120001.jpg`
- `foundation-detail1-20250525952577.jpg`
- `eyeshadow-techniques-20250525120002.jpg`

## 质量检查清单

- [ ] 图片尺寸为800x400像素
- [ ] 文件格式为JPG
- [ ] 文件大小<100KB
- [ ] 图片无水印
- [ ] 图片无文字
- [ ] 图片内容符合文章主题
- [ ] 文件名包含正确的时间戳

## 注意事项

1. **版权问题**: 使用AI生成的图片或免费图库图片，确保无版权风险
2. **水印问题**: 部分AI工具会添加水印，需要选择无水印选项
3. **文件大小**: 必须控制在100KB以内，可能需要多次压缩
4. **命名一致性**: 图片文件名必须与JSON中的URL一致

## 快速开始

### 生成示例图片（已提供）
已生成6张示例图片在 `/workspace/images/`:
- `foundation-guide-20250525120001_1.jpg`
- `foundation-detail1-20250525952577_1.jpg`
- `eyeshadow-techniques-20250525120002_1.jpg`
- `skincare-routine-cover.jpg`
- `hair-nails-cover.jpg`
- `fragrance-cover.jpg`

### 批量生成全部450张
```bash
cd /data/user/work
python3 generate_with_seedream.py
```

预计时间: 约2-3小时（取决于API速率限制）

## 技术支持

如有问题，请检查:
1. API密钥是否正确配置
2. 网络连接是否正常
3. 磁盘空间是否充足（约需500MB）
