import 'package:flutter/material.dart';
import 'package:flutter_utils/extensions/extensions.dart';
import 'package:flutter_utils/id/id_utils.dart';
import 'package:flutter_utils/number/number_utils.dart';

/// Created by Haoyi on 2021/8/21
///

part './route_path.dart';

part './global_route_observer.dart';

part './route_utils.dart';

part './route_matcher.dart';

typedef UriChecker = bool Function(Uri);
typedef PathDispatcher = Future<dynamic> Function(BuildContext, Uri);
