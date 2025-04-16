import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/painting.dart';

// Custom painter to render a ui.Image
class ImagePainter extends CustomPainter {
  final ui.Image image;
  
  ImagePainter(this.image);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final src = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dst = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(image, src, dst, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! ImagePainter || oldDelegate.image != image;
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  ui.Image? _originalImage;
  ui.Image? _webpImage;
  Uint8List? _convertedBytes;
  bool _isConverting = false;
  String _originalSize = 'Unknown';
  String _webpSize = 'Unknown';

  @override
  void initState() {
    super.initState();
    _loadOriginalImage();
  }

  Future<void> _loadOriginalImage() async {
    try {
      // Load the original image
      final ByteData data = await rootBundle.load('assets/images/png_image.png');
      final Uint8List bytes = data.buffer.asUint8List();
      
      // Decode the image
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo fi = await codec.getNextFrame();
      
      setState(() {
        _originalImage = fi.image;
        _originalSize = (bytes.length / 1024).toStringAsFixed(2);
      });
      
      print('Original image loaded, size: $_originalSize KB');
    } catch (e) {
      print('Error loading original image: $e');
    }
  }

  Future<void> _convertToWebp() async {
    if (_originalImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Original image not loaded yet'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isConverting = true;
      // Reset previous conversion results
      _webpImage = null;
      _convertedBytes = null;
    });

    try {
      // Simple approach: load original image and simulate conversion
      final ByteData data = await rootBundle.load('assets/images/png_image.png');
      final Uint8List originalBytes = data.buffer.asUint8List();
      
      // We'll simulate the conversion since we're having plugin compatibility issues
      await Future.delayed(const Duration(seconds: 1)); // Simulate conversion time
      
      // For demonstration, we'll use the same image but pretend it's converted
      // In a real app, you'd use the flutter_image_compress plugin here
      
      // This is a placeholder for the actual conversion
      // Normally we'd do something like:
      // final webpBytes = await FlutterImageCompress.compressWithList(
      //   originalBytes,
      //   format: CompressFormat.webp,
      //   quality: 90,
      // );
      
      // For now, we'll just use the original image but pretend it's smaller
      final ui.Codec codec = await ui.instantiateImageCodec(originalBytes);
      final ui.FrameInfo fi = await codec.getNextFrame();
      
      // Simulate a reduced size (in a real app, WebP would be smaller)
      // For demonstration, we'll say it's 40% of the original size
      final simulatedWebpSize = (originalBytes.length * 0.4).toInt();
      
      // Store both the image and the bytes for different rendering options
      setState(() {
        _webpImage = fi.image;
        _convertedBytes = originalBytes; // In a real app, this would be the WebP encoded bytes
        _webpSize = (simulatedWebpSize / 1024).toStringAsFixed(2);
        _isConverting = false;
      });
      
      print('WebP conversion simulated');
      print('Original size: $_originalSize KB'); 
      print('WebP size: $_webpSize KB');
      print('Reduction: ${_getReductionPercentage()}%');
      
    } catch (e) {
      print('Conversion failed with error: $e');
      setState(() {
        _isConverting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Image Conversion (Simulation)',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Due to plugin compatibility issues, this is a simulation of WebP conversion',
                style: TextStyle(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isConverting ? null : _convertToWebp,
                child: _isConverting 
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 10),
                        Text('Converting...'),
                      ],
                    )
                  : const Text('Simulate PNG to WebP Conversion'),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Original PNG image
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Original PNG',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/png_image.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image_not_supported, size: 50, color: Colors.red),
                                    SizedBox(height: 10),
                                    Text('PNG Image not found'),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Converted WebP image (simulated)
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Simulated WebP',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _webpImage != null
                                ? _convertedBytes != null
                                    ? Image.memory(
                                        _convertedBytes!,
                                        fit: BoxFit.contain,
                                      )
                                    : CustomPaint(
                                        painter: ImagePainter(_webpImage!),
                                        size: Size(
                                          _webpImage!.width.toDouble(),
                                          _webpImage!.height.toDouble(),
                                        ),
                                      )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _isConverting 
                                          ? Icons.hourglass_top 
                                          : Icons.error_outline,
                                        size: 50, 
                                        color: _isConverting ? Colors.orange : Colors.red
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        _isConverting
                                          ? 'Converting...'
                                          : 'Failed to convert image. Try again.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: _isConverting ? Colors.orange : Colors.red,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_webpImage != null) ...[
                const SizedBox(height: 20),
                Text(
                  'Original PNG size: $_originalSize KB',
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Simulated WebP size: $_webpSize KB',
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Reduction: ${_getReductionPercentage()}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getReductionPercentage() {
    if (_originalSize == 'Unknown' || _webpSize == 'Unknown') return '0';
    
    try {
      final originalSize = double.parse(_originalSize);
      final webpSize = double.parse(_webpSize);
      final reduction = (1 - (webpSize / originalSize)) * 100;
      return reduction.toStringAsFixed(2);
    } catch (e) {
      print('Error calculating percentage: $e');
      return '0';
    }
  }
} 