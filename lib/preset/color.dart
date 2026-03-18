import 'package:flutter/material.dart';

// NeverSink Style Tiers (Background Colors)
const Color TIER_1_BG = Color(0xFFFFFFFF); // White
const Color TIER_2_BG = Color(0xFFB00000); // Dark Red
const Color TIER_3_BG = Color(0xFFF0E000); // Yellow
const Color TIER_4_BG = Color(0xFF404040); // Grey/Blue
const Color TIER_5_BG = Color(0x33000000); // Transparent/Dark (Alpha 20%)

// NeverSink Style Tiers (Text Colors)
const Color TIER_1_TEXT = Color(0xFFFF0000); // Red
const Color TIER_2_TEXT = Color(0xFFFFFFFF); // White
const Color TIER_3_TEXT = Color(0xFF000000); // Black
const Color TIER_4_TEXT = Color(0xFFFFFFFF); // White
const Color TIER_5_TEXT = Color(0xFFD1D1D1); // Light Grey

// Legacy Compatibility (Mapped to Tiers)
Color OVER_FORTY = TIER_1_BG;
Color OVER_TWENTY = TIER_2_BG;
Color OVER_TEN = TIER_3_BG;
Color OVER_FOUR = TIER_4_BG;
Color DEFAULT = TIER_5_BG;

Color SUBTITLE = Colors.grey.withAlpha(100);
