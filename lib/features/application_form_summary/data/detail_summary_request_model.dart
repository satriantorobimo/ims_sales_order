class DetailSummaryRequestModel {
  String? pApplicationNo;
  int? pClientSignId;
  String? pFileNameClient;
  String? pBase64Client;
  int? pClientSpouseSignId;
  String? pFileNameSpouse;
  String? pBase64Spouse;

  DetailSummaryRequestModel(
      {this.pApplicationNo,
      this.pClientSignId,
      this.pFileNameClient,
      this.pBase64Client,
      this.pClientSpouseSignId,
      this.pFileNameSpouse,
      this.pBase64Spouse});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['p_application_no'] = pApplicationNo;
    data['p_id_client'] = pClientSignId;
    data['p_file_name_client'] = pFileNameClient;
    data['p_base64_client'] = pBase64Client;
    data['p_id_spouse'] = pClientSpouseSignId;
    data['p_file_name_spouse'] = pFileNameSpouse;
    data['p_base64_spouse'] = pBase64Spouse;
    return data;
  }
}
