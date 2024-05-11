class EbbotUserConfiguration {
  final Map<String, dynamic> userAttributes;

  EbbotUserConfiguration._builder(EbbotUserConfigurationBuilder builder)
      : userAttributes = builder._userAttributes;
}

class EbbotUserConfigurationBuilder {
  final Map<String, dynamic> _userAttributes = {};

  EbbotUserConfigurationBuilder userAttributes(
      Map<String, dynamic> userAttributes) {
    _userAttributes.addAll(userAttributes);
    return this;
  }

  EbbotUserConfiguration build() {
    return EbbotUserConfiguration._builder(this);
  }
}
