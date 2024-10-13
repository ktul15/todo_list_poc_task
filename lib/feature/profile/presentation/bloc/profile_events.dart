sealed class ProfileEvents {
  const ProfileEvents();
}

class ProfileImageSelected extends ProfileEvents {
  final String image;

  const ProfileImageSelected({required this.image});
}

class ProfileNameUpdated extends ProfileEvents {
  final String name;

  const ProfileNameUpdated({required this.name});
}

class ProfileNameChanged extends ProfileEvents {
  final String name;

  const ProfileNameChanged({required this.name});
}

class ProfileEmailUpdated extends ProfileEvents {
  final String email;

  const ProfileEmailUpdated({required this.email});
}

class ProfileEmailChanged extends ProfileEvents {
  final String email;

  const ProfileEmailChanged({required this.email});
}
