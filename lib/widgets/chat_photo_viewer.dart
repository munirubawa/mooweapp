import 'package:mooweapp/export_files.dart';

class ChatPhotoViewer extends StatefulWidget {
  PictureMessage images;
  int tabIndex;
   ChatPhotoViewer({Key? key, required this.images, required this.tabIndex}) : super(key: key);

  @override
  State<ChatPhotoViewer> createState() => _ChatPhotoViewerState();
}

class _ChatPhotoViewerState extends State<ChatPhotoViewer> {
  int _currentIndex = 0;
  late PageController pageController;
  final CarouselController _carouselController = CarouselController();
  @override
  void initState() {
    _currentIndex = widget.tabIndex;
    pageController = PageController(initialPage: widget.tabIndex);
    // TODO: implement initState
    super.initState();

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    Get.context!.dependOnInheritedWidgetOfExactType();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        automaticallyImplyLeading: false,backgroundColor: Colors.black,),
      // body: PhotoView(
      //   imageProvider: FileImage(File(filePath)),
      //   minScale: PhotoViewComputedScale.contained * 0.8,
      //   maxScale: PhotoViewComputedScale.covered * 1.8,
      //   enableRotation: true,
      // ),

      body: _buldContent(),
    );

  }

  Widget _buldContent(){
    return Column(
      children: [
        Expanded(child: _photoViewGallery()),
        Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: _buildImageCarousel(),
          ),
        ),
      ],
    );
  }


  Widget _buildImageCarousel() {
    return CarouselSlider.builder(
      itemCount: widget.images.imageUrls!.length,
      itemBuilder: (BuildContext context, int index, int id) {
        return PorfolioGalleryImageWidget(
          imagePath: widget.images.imageUrls![index],
          onImageTap: () {
            pageController.jumpToPage(index);
          },
        );
      },
      carouselController: _carouselController,
      options: CarouselOptions(
        initialPage: _currentIndex,
      aspectRatio: 6.9,
      enlargeCenterPage: false,
      viewportFraction: 0.25,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
    ),
    );
  }
  PhotoViewGallery _photoViewGallery (){
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider:  FileImage(File(storage.imagePath(widget.images.imageUrls![index])),),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 1.8,
        );
      },
      itemCount: widget.images.imageUrls!.length,
      loadingBuilder: (context, event) => Center(
        child: SizedBox(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / event.cumulativeBytesLoaded,
          ),
        ),
      ),
      // backgroundDecoration: widget.backgroundDecoration,
      pageController: pageController,
      onPageChanged: (int index){
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}



class PorfolioGalleryImageWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onImageTap;
bool? isNetworkImage = false;
   PorfolioGalleryImageWidget(
      {Key? key, required this.imagePath, required this.onImageTap, this.isNetworkImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(2, 2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Material(
          child: Ink.image(
            image: FileImage(File(storage.imagePath(imagePath),)),
            fit: BoxFit.cover,
            child: InkWell(onTap: onImageTap),
          ),
        ),
      ),
    );
  }
}