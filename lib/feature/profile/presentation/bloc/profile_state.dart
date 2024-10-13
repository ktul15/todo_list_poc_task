class ProfileState {
  bool isLoading;
  String image;
  String userName;
  String email;

  ProfileState({
    required this.isLoading,
    required this.userName,
    required this.image,
    required this.email,
  });

  ProfileState copyWith({
    String? image,
    String? userName,
    String? email,
    bool? isLoading,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      userName: userName ?? this.userName,
      image: image ?? this.image,
      email: email ?? this.email,
    );
  }
}
