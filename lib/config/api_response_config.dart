
import '../api/api_response.dart';

bool isLoading(ApiResponse response) {
  return response.status == Status.LOADING || response.status == Status.INITIAL;
}

bool isInitial(ApiResponse response) {
  return response.status == Status.INITIAL;
}

bool isError(ApiResponse response) {
  return response.status == Status.ERROR;
}

bool isComplete(ApiResponse response) {
  return response.status == Status.COMPLETED;
}

bool isLoadingOnly(ApiResponse response) {
  return response.status == Status.LOADING;
}

bool isFinish(ApiResponse response) {
  return response.status == Status.COMPLETED || response.status == Status.ERROR;
}

bool notLoading(ApiResponse response) {
  return response.status != Status.LOADING;
}
