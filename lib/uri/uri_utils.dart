/// Created by @RealCradle on 4/30/21

class UriUtils {
  static bool isAssetsPath(String path) {
    return path[0] == 'a' &&
        path[1] == 's' &&
        path[2] == 's' &&
        path[3] == 'e' &&
        path[4] == 't' &&
        path[5] == 's';
  }

  static bool isNetworkPath(String path) {
    return path[0] == 'h' && path[1] == 't' && path[2] == 't' && path[3] == 'p';
  }

  static bool isFilePath(String path) {
    return path[0] == '/';
  }
}
