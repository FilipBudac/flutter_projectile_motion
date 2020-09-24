class NetworkError extends Error {}
class PointNotFound extends Error {}

class ErrorMessage {
  static const String CAMERA_PERMISSION = "Camera permission not granted.";
  static const String NETWORK_ERROR = "Network Error.";
  static const String POINT_NOT_FOUND = "Data requested from server have been lost.";

}