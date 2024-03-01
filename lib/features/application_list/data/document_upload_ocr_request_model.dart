class DocumentUploadOCRRequestModel {
  String? pModule;
  String? pHeader;
  String? pChild;
  int? pId;
  int? pFilePath;
  String? pFileName;
  String? pBase64;

  DocumentUploadOCRRequestModel(
      {this.pModule,
      this.pHeader,
      this.pChild,
      this.pId,
      this.pFilePath,
      this.pFileName,
      this.pBase64});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['p_module'] = pModule;
    data['p_header'] = pHeader;
    data['p_child'] = pChild;
    data['p_id'] = pId;
    data['p_file_path'] = pFilePath;
    data['p_file_name'] = pFileName;
    data['p_base64'] = pBase64;
    return data;
  }
}
