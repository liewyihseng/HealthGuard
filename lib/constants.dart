library constants;

import 'package:flutter/material.dart';

import 'dart:ui';


/// Database
const USERS = 'users';
const RECORDS = "health_records";
const ACC_INFO = "acc_info";
const MED_INFO = "medical_info";
const MEDICATION_INFO = "medication_info";
const PEDOMETER_INFO = "pedometer_info";

/// Colours
const BUTTON_COLOUR = Color(0xFF33ac8d);

const LOGO_COLOUR_PINK_LIGHT = Color(0xFFf27184);
const LOGO_COLOUR_PINK_DARK = Color(0xFFe4848d);

const LOGO_COLOUR_GREEN_LIGHT = Color(0xFF2abb99);
const LOGO_COLOUR_GREEN_DARK = Color(0xFF33ac8d);

const TEXT_SUPER_LIGHT = Color(0xFFC9C9C9);
const TEXT_LIGHT = Color(0xFF486581);
const TEXT_DARK = Color(0xFF102A43);

const BACKGROUND_COLOUR = Color(0xFFF5F5F7);

/// Font
const FONTSTYLE = "Montserrat";

/// Appbar
const APPBAR_TEXT_WEIGHT = FontWeight.w900;

const APPBAR_COLOUR = Color(0xFF2abb99);

/// TextStyle
const TextStyle ALERT_DIALOG_TITLE_STYLE = TextStyle(
  fontFamily: FONTSTYLE,
  fontWeight: APPBAR_TEXT_WEIGHT,
  color: TEXT_DARK,
);

const TextStyle APP_BAR_TEXT_STYLE = TextStyle(
  color: Colors.white,
  fontFamily: FONTSTYLE,
  fontWeight: APPBAR_TEXT_WEIGHT,
  fontSize: 20,
);


/// API Key
const GoogleApiKey = "AIzaSyCwIvvIxm9yn4JXoEHoaAx7wn2WySONi7M";


