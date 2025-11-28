#!/bin/bash

# AI Notetaker App Icon Generator
# This script creates modern app icons in all required sizes

echo "🎨 Creating AI Notetaker App Icons..."

# Create AppIcon assets directory
mkdir -p "AppIcon.appiconset"

# Create base icon using ImageMagick if available
# This creates a modern blue gradient with note icon and AI badge

# Create 1024x1024 App Store icon
convert -size 1024x1024 xc:none \
    -fill "linear-gradient(45deg, #007AFF, #0054CC)" \
    -draw "rectangle 0,0 1024,1024" \
    -fill white \
    -draw "roundRectangle 307,256 717,768 40,40" \
    -fill "#007AFF" \
    -draw "rectangle 327,290 467,305" \
    -draw "rectangle 497,290 637,305" \
    -draw "rectangle 357,320 517,335" \
    -draw "rectangle 547,320 607,335" \
    -draw "rectangle 337,350 487,365" \
    -draw "rectangle 517,350 577,365" \
    -font "Arial Rounded MT Bold" \
    -fill "#0054CC" \
    -pointsize 82 \
    -gravity northwest \
    -draw "text 720,100 'AI'" \
    AppIcon.appiconset/AppIcon-1024@1x.png 2>/dev/null

# If ImageMagick is not available, create a placeholder script
if [ ! -f "AppIcon.appiconset/AppIcon-1024@1x.png" ]; then
    echo "📝 ImageMagick not found. Creating placeholder instructions..."

    cat > AppIcon.appiconset/README.md << 'EOF'
# AI Notetaker App Icons

## Design Specifications
- **Primary Color**: Blue gradient (#007AFF to #0054CC)
- **Icon**: Modern note/document with text lines
- **AI Badge**: Small "AI" text in corner
- **Style**: Clean, modern, rounded corners

## Required Sizes
- App Store: 1024x1024
- iPhone: 180x180, 120x120, 80x80, 60x60, 40x40, 29x29, 20x20
- iPad: 167x167, 152x152, 76x76, 40x40
- Mac App Store: 512x512, 256x256

## Implementation Options

### 1. Use SwiftUI App Icon Generator
Run the App Icon Generator.swift file in Xcode and export as PNGs.

### 2. Use Online Tools
- Canva.com (search "app icon template")
- AppIcon.co (icon generator)
- MakeAppIcon.com

### 3. Use Professional Design Tools
- Sketch/Figma (create design and export)
- Adobe Illustrator (professional design)
- Affinity Designer (affordable alternative)

### 4. AI-Based Generation
- Midjourney prompt: "modern app icon for AI note taking app, blue gradient, clean design, iOS style, professional"
- DALL-E prompt: "app icon for AI note taking application, minimalist design, blue gradient, rounded corners"
- Stable Diffusion with app icon models
EOF

else
    echo "✅ Base 1024x1024 icon created successfully!"

    # Create smaller versions by resizing
    for size in 512 256 180 167 152 120 80 76 60 40 29 20; do
        convert AppIcon.appiconset/AppIcon-1024@1x.png -resize ${size}x${size} AppIcon.appiconset/AppIcon-${size}x${size}@1x.png
        echo "✅ Created ${size}x${size} icon"
    done

    # Create @2x and @3x versions for retina displays
    for size in 60 80 120; do
        convert AppIcon.appiconset/AppIcon-${size}x${size}@1x.png -resize $((${size}*2))x$((${size}*2)) AppIcon.appiconset/AppIcon-${size}x${size}@2x.png
        if [ "$size" = "60" ]; then
            convert AppIcon.appiconset/AppIcon-${size}x${size}@1x.png -resize $((${size}*3))x$((${size}*3)) AppIcon.appiconset/AppIcon-${size}x${size}@3x.png
        fi
    done

    echo "✅ All icon variations created!"
fi

# Create Contents.json for Xcode
cat > AppIcon.appiconset/Contents.json << 'EOF'
{
  "images" : [
    {
      "idiom" : "universal",
      "platform" : "ios",
      "size" : "1024x1024"
    },
    {
      "idiom" : "universal",
      "platform" : "mac",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

echo "🎉 App icon creation complete!"
echo "📁 Icons saved in AppIcon.appiconset/"
echo "📋 Drag AppIcon.appiconset into your Xcode project Assets.xcassets folder"