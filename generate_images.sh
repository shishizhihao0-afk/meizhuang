#!/bin/bash
# 批量图片生成脚本
# 使用 ImageMagick 或 AI 图片生成工具

# 创建输出目录
mkdir -p /workspace/images

# 图片规格
WIDTH=800
HEIGHT=400
QUALITY=85

# 生成图片函数
generate_image() {
    local filename=$1
    local prompt=$2
    
    echo "Generating: $filename"
    
    # 方法1: 使用 ImageMagick 生成占位图（带颜色）
    # convert -size ${WIDTH}x${HEIGHT} xc:lightblue -pointsize 30 -fill black -gravity center -annotate +0+0 "$prompt" "/workspace/images/${filename}.jpeg"
    
    # 方法2: 使用 AI 生成（需要配置 API）
    # python3 generate_ai_image.py "$prompt" "/workspace/images/${filename}.jpeg"
}

# 读取任务列表并生成
python3 << 'PYTHON_EOF'
import json

with open('/workspace/image_generation_tasks.json', 'r') as f:
    tasks = json.load(f)

# 为每个任务生成提示词并输出命令
for task in tasks:
    category = task['category']
    img_type = task['type']
    filename = task['filename']
    
    # 根据分类和类型选择提示词模板
    prompts = {
        'Makeup': {
            'cover': 'Professional makeup products flat lay, foundation lipstick eyeshadow, marble surface, soft lighting, commercial photography, no text',
            'inline': 'Makeup application close-up, brush on skin, beauty photography, natural light, no text'
        },
        'Skin Care': {
            'cover': 'Luxury skincare products, serums moisturizers, glass bottles, clean white background, spa aesthetic, no text',
            'inline': 'Facial care application, glowing skin, beauty photography, soft light, no text'
        },
        'Hair & Nails': {
            'cover': 'Hair care products styling tools, salon aesthetic, marble background, professional photography, no text',
            'inline': 'Beautiful manicured hands, nail polish detail, soft lighting, beauty photography, no text'
        },
        'Fragrances': {
            'cover': 'Elegant perfume bottles, golden liquid, flowers, luxury aesthetic, soft bokeh, no text',
            'inline': 'Perfume bottle with mist, artistic composition, luxury fragrance photography, no text'
        },
        'Cosmetic Procedures': {
            'cover': 'Modern aesthetic clinic, professional beauty equipment, clean medical environment, soft lighting, no text',
            'inline': 'Beauty treatment procedure, professional skin care, medical aesthetic, no text'
        }
    }
    
    prompt = prompts.get(category, {}).get(img_type, 'Beauty product photography, professional lighting, no text')
    
    print(f'generate_image "{filename}" "{prompt}"')

PYTHON_EOF

echo "图片生成命令已生成"
echo "请根据您的图片生成工具（Midjourney/DALL-E/Stable Diffusion）执行相应命令"
