# Image WebP Converter

A Flutter application that demonstrates image conversion from PNG to WebP format.

## Features

- Display images from asset folder
- Side-by-side comparison of original PNG and converted WebP images
- Visual representation of file size reduction
- Error handling and loading states
- Responsive UI with proper feedback

## Screenshots

![App Screenshot](https://github.com/yourusername/image_webp_converter/raw/main/screenshots/Screenshot_1.png)

The screenshot above shows the main interface of the app with:
- Clean, modern UI with a purple theme
- "Simulate PNG to WebP Conversion" button at the top
- Side-by-side comparison of images (Original PNG on left, WebP on right)
- Size statistics at the bottom showing the original size, converted size, and percentage reduction
- In this example, a 60% file size reduction is achieved (1700.24 KB → 680.10 KB)

## How It Works

This application demonstrates the concept of image conversion from PNG to WebP. WebP is a modern image format that provides superior lossless and lossy compression for images on the web, resulting in smaller file sizes while maintaining visual quality.

In the current implementation:
- The app loads an image from the assets folder
- When you click the "Simulate PNG to WebP Conversion" button, it simulates the conversion process
- It displays both images side by side for comparison
- It shows size statistics including the reduction percentage

## Setup Instructions

1. Clone the repository:
```
git clone https://github.com/yourusername/image_webp_converter.git
```

2. Navigate to the project directory:
```
cd image_webp_converter
```

3. Install dependencies:
```
flutter pub get
```

4. Add images to convert:
   - Place your images in the `assets/images/` directory
   - Make sure to update the pubspec.yaml file if needed

5. Run the app:
```
flutter run
```

## Dependencies

- Flutter SDK
- dart:ui for image processing
- Flutter's built-in image rendering capabilities

## Note on WebP Conversion

In a production app, actual WebP conversion would typically use plugins like `flutter_image_compress`. This sample app simulates the conversion process to demonstrate the UI and workflow.

## Future Improvements

- Implement actual WebP conversion using native code
- Add support for selecting images from gallery/camera
- Add support for saving converted images
- Add more conversion options (quality settings, etc.)

## License

This project is open source and available under the MIT License.
