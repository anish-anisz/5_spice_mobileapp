class ItemRequestModel {
  final int sno;
  final String itemName;
  final String category;
  final String availability;     // Available / Unavailable
  final String? requestTime;     // Nullable (because "-" in some rows)
  final String? approvalStatus;  // Pending / Approved
  final String? approvedBy;
  final String? actionTime;
  final String? tat;             // Turn Around Time

  ItemRequestModel({
    required this.sno,
    required this.itemName,
    required this.category,
    required this.availability,
    this.requestTime,
    this.approvalStatus,
    this.approvedBy,
    this.actionTime,
    this.tat,
  });

  factory ItemRequestModel.fromJson(Map<String, dynamic> json) {
    return ItemRequestModel(
      sno: json['sno'],
      itemName: json['item_name'],
      category: json['category'],
      availability: json['availability'],
      requestTime: json['request_time'],
      approvalStatus: json['approval_status'],
      approvedBy: json['approved_by'],
      actionTime: json['action_time'],
      tat: json['tat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sno': sno,
      'item_name': itemName,
      'category': category,
      'availability': availability,
      'request_time': requestTime,
      'approval_status': approvalStatus,
      'approved_by': approvedBy,
      'action_time': actionTime,
      'tat': tat,
    };
  }
}
