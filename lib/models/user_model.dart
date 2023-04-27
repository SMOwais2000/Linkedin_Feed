class UserModel {
  final String name;
  final String connections;
  final String viewProfile;
  final String headline;
  final String profileUrl;

  UserModel(
      {this.name,
      this.headline,
      this.connections,
      this.profileUrl,
      this.viewProfile});
}

class UserPostModel {
  final String name;
  final String connections;
  final String description;
  final String headline;
  final String profileUrl;
  final String video;
  final String image;
  final String comments;
  final String likes;
  final String tags;
  final bool isOnline;
  final bool isVideoPost;

  UserPostModel(
      {this.name,
      this.headline,
      this.connections,
      this.profileUrl,
      this.comments,
      this.description,
      this.image,
      this.isOnline,
      this.isVideoPost,
      this.likes,
      this.tags,
      this.video});
}
