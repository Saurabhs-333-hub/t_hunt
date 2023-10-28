enum PostType {
  caption('caption'),
  image('image');

  final String type;
  const PostType(this.type);
}

extension ConvertPost on String{
  PostType toPostType(){
    switch(this){
      case 'caption':
        return PostType.caption;
      case 'image':
        return PostType.image;
      default:
        return PostType.caption;
    }
  }
}

enum StoryType {
  caption('caption'),
  image('image');

  final String type;
  const StoryType(this.type);
}

extension ConvertStory on String {
  StoryType toStoryType() {
    switch (this) {
      case 'caption':
        return StoryType.caption;
      case 'image':
        return StoryType.image;
      default:
        return StoryType.caption;
    }
  }
}
