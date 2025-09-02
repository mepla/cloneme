import 'package:flutter/material.dart';

class EvermyndLogo extends StatelessWidget {
  final LogoSize size;

  const EvermyndLogo({
    super.key,
    this.size = LogoSize.large,
  });

  @override
  Widget build(BuildContext context) {
    final double fontSize = size == LogoSize.small ? 24 : 40;
    final double starSize = size == LogoSize.small ? 16 : 22;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // "Everm" part
        _buildGradientText('Everm', fontSize),
        
        // "y" with star above
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            _buildGradientText('y', fontSize),
            Positioned(
              top: size == LogoSize.small ? -8 : -10,
              child: _buildGradientText('✦', starSize),
            ),
          ],
        ),
        
        // "nd" part
        _buildGradientText('nd', fontSize),
      ],
    );
  }

  Widget _buildGradientText(String text, double fontSize) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          Color(0xFF8C52FF), // primary-400 equivalent
          Color(0xFF4D0F99), // primary-600 equivalent
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white, // This will be masked by the gradient
        ),
      ),
    );
  }
}

enum LogoSize {
  small,
  large,
}