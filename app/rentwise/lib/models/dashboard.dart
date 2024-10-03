

class MDashboardData{
  final int roomAllCounter;
  final int roomOccupiedCounter;
  final int pAwaitingPayment;
  final int pAwaitingConfirmation;
  final int pPaidPayment;
  final int cAwaitingReview;
  final int cInProgress;
  final int cCompleted;

  const MDashboardData({
    required this.roomAllCounter,
    required this.roomOccupiedCounter,
    required this.pAwaitingPayment,
    required this.pAwaitingConfirmation,
    required this.pPaidPayment,
    required this.cAwaitingReview,
    required this.cInProgress,
    required this.cCompleted
  });

  factory MDashboardData.fromJson(Map<String, dynamic> json) => MDashboardData(
    roomAllCounter: json["roomAllCounter"],
    roomOccupiedCounter: json["roomOccupiedCounter"],
    pAwaitingPayment: json["pAwaitingPayment"],
    pAwaitingConfirmation: json["pAwaitingConfirmation"],
    pPaidPayment: json["pPaidPayment"],
    cAwaitingReview: json["cAwaitingReview"],
    cInProgress: json["cInProgress"],
    cCompleted: json["cCompleted"]
  );
}

class TDashboardData{
  final String roomName;
  final String roomPrice;
  final String roomFloor;
  final String pPrice;
  final String pStatus;
  final String cComplaintName;
  final String cStatus;

  const TDashboardData({
    required this.roomName,
    required this.roomPrice,
    required this.roomFloor,
    required this.pPrice,
    required this.pStatus,
    required this.cComplaintName,
    required this.cStatus
  });

  factory TDashboardData.fromJson(Map<String, dynamic> json) => TDashboardData(
    roomName: json["roomName"],
    roomPrice: json["roomPrice"],
    roomFloor: json["roomFloor"],
    pPrice: json["pPrice"],
    pStatus: json["pStatus"],
    cComplaintName: json["cComplaintName"],
    cStatus: json["cStatus"]
  );
}