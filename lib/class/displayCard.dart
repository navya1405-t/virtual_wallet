class DisplayCard {
  final String id;
  final String cardType;
  final String filename;
  final String uploadedOn;
  final String frontPictureUrl;
  final String backPictureUrl;

  DisplayCard({
    required this.id,
    required this.cardType,
    required this.filename,
    required this.uploadedOn,
    required this.frontPictureUrl,
    required this.backPictureUrl,
  });
}
