import '../liblist/my_lib.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class CustomAppBarState extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey, CustomColors.mintWhite],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
      ),
      toolbarHeight: 80,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Apply the borderRadius
      ),
      title: Center(
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.yellow, Colors.orange],
            tileMode: TileMode.mirror,
          ).createShader(bounds),
          child: FadeTransition(
            opacity: _controller,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'EXP',
                    style: CustomColors.headerText.copyWith(
                      shadows: <Shadow>[
                        const Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ],
                    ),
                  ),
                  TextSpan(
                    text: 'date',
                    style: CustomColors.header2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
