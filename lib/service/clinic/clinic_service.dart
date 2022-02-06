import 'package:skipq_clinic/main.dart';
import 'package:skipq_clinic/models/api_response_model.dart';
import 'package:skipq_clinic/models/clinic_model.dart';
import 'package:skipq_clinic/models/clinic_token_model.dart';
import 'package:skipq_clinic/models/notification/notification_model.dart';
import 'package:skipq_clinic/models/subscription_model/order_model.dart';
import 'package:skipq_clinic/models/subscription_model/plan_model.dart';
import 'package:skipq_clinic/models/subscription_model/subscription_model.dart';
// import 'package:skipq_clinic/models/service_model.dart/clinic/clinic_model.dart';
// import 'package:skipq_clinic/models/service_model.dart/clinic/clinic_token_model.dart';
import 'package:skipq_clinic/service/api_service.dart';

class ClinicService {
  ApiService _apiService = getIt.get<ApiService>();

  Future<ServiceResponse> updateProfile(data) async {
    ApiResponse apiResponse = await _apiService.post("/clinic/profile/update-profile", data);

    print('Error Msg');
    print(apiResponse.errMsg);

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }

    return ServiceResponse(apiResponse, data: Clinic.fromJson(apiResponse.data));
  }

  Future<ServiceResponse> getPendingToken(String id) async {
    ApiResponse apiResponse = await _apiService.get("/clinic/queue/get-pending-tokens/$id");

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }

    return ServiceResponse(apiResponse, data: apiResponse.data.map<ClinicToken>((e) {
      return ClinicToken.fromJson(e);
    }));
  }

  Future<ServiceResponse> getRequests() async {
    ApiResponse apiResponse = await _apiService.get("/clinic/queue/get-requests");

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }

    return ServiceResponse(apiResponse, data: apiResponse.data.map<ClinicToken>((e) {
      return ClinicToken.fromJson(e);
    }));
  }

  Future<ServiceResponse> startClinic() async {
    ApiResponse apiResponse = await _apiService.put("/clinic/queue/start-clinic");

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }

    print(apiResponse.data);

    return ServiceResponse(apiResponse, data: Clinic.fromJson(apiResponse.data));
  }

  Future<ServiceResponse> stopClinic() async {
    ApiResponse apiResponse = await _apiService.put("/clinic/queue/stop-clinic");

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }

    return ServiceResponse(apiResponse, data: Clinic.fromJson(apiResponse.data));
  }

  Future<ServiceResponse> addOfflineToken(String? name) async {
    ApiResponse apiResponse = await _apiService.post("/clinic/queue/create-offline-token", name == null ? {} : {'userName': name});

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }

    return ServiceResponse(apiResponse, data: ClinicToken.fromJson(apiResponse.data));
  }

  Future<ServiceResponse> completeToken(String id) async {
    ApiResponse apiResponse = await _apiService.post("/clinic/queue/complete-token", {"tokenId": id});

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }

    return ServiceResponse(apiResponse, data: ClinicToken.fromJson(apiResponse.data));
  }

  Future<ServiceResponse> discardToken(String id) async {
    ApiResponse apiResponse = await _apiService.post("/clinic/queue/reject-token", {"tokenId": id});

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }

    return ServiceResponse(apiResponse, data: ClinicToken.fromJson(apiResponse.data));
  }

  Future<ServiceResponse> acceptRequest(String id) async {
    ApiResponse apiResponse = await _apiService.post("/clinic/queue/accept-request", {"tokenId": id});

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }

    return ServiceResponse(apiResponse, data: ClinicToken.fromJson(apiResponse.data));
  }

  Future<ServiceResponse> rejectRequest(String id) async {
    ApiResponse apiResponse = await _apiService.post("/clinic/queue/reject-request", {"tokenId": id});

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }

    return ServiceResponse(apiResponse, data: ClinicToken.fromJson(apiResponse.data));
  }

  Future<ServiceResponse> getTransactionToken(months) async {
    ApiResponse apiResponse = await _apiService.post("/clinic/transaction/generate-checksum", {"months": months});

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }

    return ServiceResponse(apiResponse, data: OrderModel.fromJson(apiResponse.data));
  }

  Future<ServiceResponse> getNotifications(int pageNo) async {
    ApiResponse apiResponse = await _apiService.get("/clinic/profile/get-notifications?pageNo=$pageNo");

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }

    return ServiceResponse(apiResponse, data: apiResponse.data.map<NotificationModel>((e) {
      return NotificationModel.fromJson(e);
    }));
  }

  Future<ServiceResponse> getSubscriptionDetails() async {
    ApiResponse apiResponse = await _apiService.get("/clinic/subscription/get-clinic-subscriptions");

    if (apiResponse.error) {
      return ServiceResponse(apiResponse);
    }

    var data = {
      "isSubscriptionRequired": apiResponse.data["isSubscriptionRequired"],
      "availablePlans": apiResponse.data["availablePlans"].map<PlanModel>((plan) => PlanModel.fromJson(plan)),
      "lastClinicSubscription": SubscriptionModel.fromJson(apiResponse.data["lastClinicSubscription"])
    };

    print(data.toString());
    return ServiceResponse(apiResponse, data: data);
  }
}
