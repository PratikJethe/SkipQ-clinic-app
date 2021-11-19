import 'package:booktokenclinicapp/main.dart';
import 'package:booktokenclinicapp/models/api_response_model.dart';
import 'package:booktokenclinicapp/models/clinic_model.dart';
import 'package:booktokenclinicapp/models/clinic_token_model.dart';
// import 'package:booktokenclinicapp/models/service_model.dart/clinic/clinic_model.dart';
// import 'package:booktokenclinicapp/models/service_model.dart/clinic/clinic_token_model.dart';
import 'package:booktokenclinicapp/service/api_service.dart';

class ClinicService {
  ApiService _apiService = getIt.get<ApiService>();

  Future<ServiceResponse> getPendingToken(String id) async {
    ApiResponse apiResponse = await _apiService.get("/clinic/queue/get-pending-tokens/$id");

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }

    return ServiceResponse(apiResponse, data: apiResponse.data.map<ClinicToken>((e) {
      return ClinicToken.fromJson(e);
    }));
  }

  Future<ServiceResponse> addOfflineToken(String? name) async {
    ApiResponse apiResponse = await _apiService.post("/clinic/queue/create-offline-token", name == null ? {} : {'userName': name});

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }

    return ServiceResponse(apiResponse, data: ClinicToken.fromJson(apiResponse.data));
  }
}
