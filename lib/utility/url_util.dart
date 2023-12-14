import 'dart:convert';

import '../../flavor_config.dart';

class UrlUtil {
  static String baseUrl = FlavorConfig.instance.values.baseUrl!;
  static String userId = FlavorConfig.instance.values.userId!;
  static final Map<String, String> headerType = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  static Map<String, String> headerTypeBasicAuth(
          String username, String password) =>
      {
        "content-type": "application/json",
        "accept": "application/json",
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$username:$password'))}'
      };

  static Map<String, String> headerTypeWithToken(String token) => {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Userid': userId
      };

  static Map<String, String> headerTypeForm() => {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

  Map<String, String> getHeaderTypeWithToken(String token) {
    return headerTypeWithToken(token);
  }

  Map<String, String> getHeaderTypeBasicAuth(String username, String password) {
    return headerTypeBasicAuth(username, password);
  }

  Map<String, String> getHeaderTypeForm() {
    return headerTypeForm();
  }

  static String urlLogin() => 'token/v5_token/api/Authenticate/request';

  String getUrlLogin() {
    final String getUrlLogin2 = urlLogin();
    return baseUrl + getUrlLogin2;
  }

  static String urlAppStatus() => 'api/mobso_api/api/Home/GetListAppStatus';

  String getUrlAppStatus() {
    final String getUrlLoginAppStatus2 = urlAppStatus();
    return baseUrl + getUrlLoginAppStatus2;
  }

  static String urlAppList() => 'api/mobso_api/api/Application/GetListApp';

  String getUrlAppList() {
    final String getUrlLoginAppList2 = urlAppList();
    return baseUrl + getUrlLoginAppList2;
  }

  static String urlClientMatchingCorp() =>
      'api/mobso_api/api/Client/MatchingCorporate';

  String getUrlClientMatchingCorp() {
    final String getUrlClientMatchingCorp2 = urlClientMatchingCorp();
    return baseUrl + getUrlClientMatchingCorp2;
  }

  static String urlClientMatchingPersonal() =>
      'api/mobso_api/api/Client/MatchingPersonal';

  String getUrlClientMatchingPersonal() {
    final String getUrlClientMatchingPersonal2 = urlClientMatchingPersonal();
    return baseUrl + getUrlClientMatchingPersonal2;
  }

  static String urlCheckScoring() => 'api/mobso_api/api/Client/CheckScoring';

  String getUrlCheckScoring() {
    final String getUrlCheckScoring2 = urlCheckScoring();
    return baseUrl + getUrlCheckScoring2;
  }

  static String urlLookUpMso() =>
      'api/mobso_api/api/SysGeneralSubcode/LookupForMSO';

  String getUrlLookUpMso() {
    final String getUrlLookUpMso2 = urlLookUpMso();
    return baseUrl + getUrlLookUpMso2;
  }

  static String urlLookUpProv() =>
      'api/mobso_api/api/SysGeneralSubcode/LookupForProvince';

  String getUrlLookUpProv() {
    final String getUrlLookUpProv2 = urlLookUpProv();
    return baseUrl + getUrlLookUpProv2;
  }

  static String urlLookUpCity() =>
      'api/mobso_api/api/SysGeneralSubcode/LookupForCity';

  String getUrlLookUpCity() {
    final String getUrlLookUpCity2 = urlLookUpCity();
    return baseUrl + getUrlLookUpCity2;
  }

  static String urlLookUpZipCode() =>
      'api/mobso_api/api/SysGeneralSubcode/LookupForZipCode';

  String getUrlLookUpZipCode() {
    final String getUrlLookUpZipCode2 = urlLookUpZipCode();
    return baseUrl + getUrlLookUpZipCode2;
  }

  static String urlLookUpBank() =>
      'api/mobso_api/api/SysGeneralSubcode/LookupForBank';

  String getUrlLookUpBank() {
    final String getUrlLookUpBank2 = urlLookUpBank();
    return baseUrl + getUrlLookUpBank2;
  }

  static String urlAddClient() => 'api/mobso_api/api/Application/AddNewClient';

  String getUrlAddClient() {
    final String getUrlAddClient2 = urlAddClient();
    return baseUrl + getUrlAddClient2;
  }

  static String urlUpdateClient() => 'api/mobso_api/api/Client/Update';

  String getUrlUpdateClient() {
    final String getUrlUpdateClient2 = urlUpdateClient();
    return baseUrl + getUrlUpdateClient2;
  }

  static String urlLookUpPackage() =>
      'api/mobso_api/api/LoanData/LookupForPackage';

  String getUrlLookUpPackage() {
    final String getUrlLookUpPackage2 = urlLookUpPackage();
    return baseUrl + getUrlLookUpPackage2;
  }

  static String urlLookUpDealer() =>
      'api/mobso_api/api/LoanData/LookupForDealer';

  String getUrlLookUpDealer() {
    final String getUrlLookUpDealer2 = urlLookUpDealer();
    return baseUrl + getUrlLookUpDealer2;
  }

  static String urlLoanDataDetail() => 'api/mobso_api/api/LoanData/GetRow';

  String getUrlLoanDataDetail() {
    final String urlLoanDataDetail2 = urlLoanDataDetail();
    return baseUrl + urlLoanDataDetail2;
  }

  static String urlUpdateLoanDataDetail() =>
      'api/mobso_api/api/LoanData/Update';

  String getUrlUpdateLoanDataDetail() {
    final String getUrlUpdateLoanDataDetail2 = urlUpdateLoanDataDetail();
    return baseUrl + getUrlUpdateLoanDataDetail2;
  }

  static String urlLookUpMerk() => 'api/mobso_api/api/Asset/LookupForMerk';

  String getUrlLookUpMerk() {
    final String getUrlLookUpMerk2 = urlLookUpMerk();
    return baseUrl + getUrlLookUpMerk2;
  }

  static String urlLookUpModel() => 'api/mobso_api/api/Asset/LookupForModel';

  String getUrlLookUpModel() {
    final String getUrlLookUpModel2 = urlLookUpModel();
    return baseUrl + getUrlLookUpModel2;
  }

  static String urlLookUpType() => 'api/mobso_api/api/Asset/LookupForType';

  String getUrlLookUpType() {
    final String getUrlLookUpType2 = urlLookUpType();
    return baseUrl + getUrlLookUpType2;
  }

  static String urlAssetDetail() => 'api/mobso_api/api/Asset/GetRow';

  String getUrlAssetDetail() {
    final String getUrlAssetDetail2 = urlAssetDetail();
    return baseUrl + getUrlAssetDetail2;
  }

  static String urlUpdateAsset() => 'api/mobso_api/api/Asset/Update';

  String getUrlUpdateAsset() {
    final String getUrlUpdateAsset2 = urlUpdateAsset();
    return baseUrl + getUrlUpdateAsset2;
  }

  static String urlAssetValidity() => 'api/mobso_api/api/Asset/CheckValidity';

  String getUrlAssetValidity() {
    final String getUrlAssetValidity2 = urlAssetValidity();
    return baseUrl + getUrlAssetValidity2;
  }

  static String urlLookUpInsurance() =>
      'api/v5_ifinins_api/api/MobsoMasterInsurancePackage/LookupForMSO';

  String getUrlLookUpInsurance() {
    final String getUrlLookUpInsurance2 = urlLookUpInsurance();
    return baseUrl + getUrlLookUpInsurance2;
  }

  static String urlTncDetail() => 'api/mobso_api/api/Tnc/GetRow';

  String getUrlTncDetail() {
    final String getUrlTncDetail2 = urlTncDetail();
    return baseUrl + getUrlTncDetail2;
  }

  static String urlTncUpdate() => 'api/mobso_api/api/Tnc/Update';

  String getUrlTncUpdate() {
    final String getUrlTncUpdate2 = urlTncUpdate();
    return baseUrl + getUrlTncUpdate2;
  }

  static String urlFeeDetail() => 'api/mobso_api/api/Fee/Getrow';

  String getUrlFeeDetail() {
    final String getUrlFeeDetail2 = urlFeeDetail();
    return baseUrl + getUrlFeeDetail2;
  }
}
