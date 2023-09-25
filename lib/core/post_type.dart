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
