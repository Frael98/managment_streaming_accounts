/* 
  Indica el tipo de plataforma
  Ejemplo:
  Netflix
  Disney
  Amazon Prime
  HBO
 */
import 'dart:ffi';

import 'package:f_managment_stream_accounts/interfaces/entity.dart';

class Platform extends Entity {
  
  Int64? idPlatform;
  String nameService;

  Platform({required this.nameService});
}