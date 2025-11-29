import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

// --- Constants for consistent styling ---
const Color kGold = Color(0xFFD4AF37); // Corrected Figma Gold
const Color kDarkBackground = Color(0xFF1E1E1E);
const Color kLighterDark = Color(0xFF2C2C2C); // Added for card/section backgrounds
const double kMobilePadding = 24.0; // Increased padding for better mobile feel
const double kSectionSpacing = 50.0; // Increased spacing for better separation
final TextStyle baseHeadingStyle = GoogleFonts.playfairDisplay(
      color: Colors.white, 
      fontSize: 28, 
      fontWeight: FontWeight.bold
    );
  final TextStyle goldenHeadingStyle = GoogleFonts.playfairDisplay(
      color: kGold, 
      fontSize: 28, 
      fontWeight: FontWeight.bold
    );

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kDarkBackground,
      body: CustomScrollView(
        slivers: <Widget>[
          // 1. App Bar (Top Navigation)
          RaghunanthamSliverAppBar(),
          
          // 2. Main Content (The rest of the sections)
          SliverToBoxAdapter(
            child: Column(
              children: [
                // --- Top Banner Section (Image Background) ---
                TopBannerSection(),
                
                // --- About Section ---
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: kMobilePadding, vertical: kSectionSpacing),
                  child: AboutSection(),
                ),
                
                // --- Vision & Mission Section ---
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: kMobilePadding, vertical: kSectionSpacing),
                  child: VisionMissionSection(),
                ),
                
                // --- Featured Properties Section (Handles own horizontal padding) ---
                FeaturedPropertiesSection(),
                
                // --- Why Choose Section ---
                WhyChooseSection(),
                
                // --- Take With Raghunantham You (App Download) ---
                AppDownloadSection(),
                
                // --- What Our Clients Say (Testimonial) ---
                TestimonialSection(),
                
                SizedBox(height: kSectionSpacing * 2), 
                
                // --- Footer Section ---
                FooterSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------
// 1. Raghunantham Sliver App Bar (Playfair Display)
// ------------------------------------------------
class RaghunanthamSliverAppBar extends StatelessWidget {
  const RaghunanthamSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: kDarkBackground,
      title: Row(
        children: [
          // Logo/Brand Name
          Text(
            'Raghunantham', 
            style: GoogleFonts.playfairDisplay(
              color: kGold, 
              fontSize: 18, 
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.menu, color: kGold, size: 28),
          onPressed: () {
            // TODO: Implement mobile menu drawer
          },
        ),
      ],
    );
  }
}

// ------------------------------------------------
// 2. Top Banner Section (Playfair Display & Inter)
// ------------------------------------------------
class TopBannerSection extends StatelessWidget {
  const TopBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the base style using Playfair Display for the main heading
    final TextStyle baseStyle = GoogleFonts.playfairDisplay(
      color: Colors.white,
      fontSize: 32,
      fontWeight: FontWeight.w900,
      height: 1.2,
    );

    // Define the golden style for the specific word
    final TextStyle goldenStyle = GoogleFonts.playfairDisplay(
      color: kGold,
      fontSize: 32,
      fontWeight: FontWeight.w900,
      height: 1.2,
    );

    return Container(
      height: 350,
      padding: const EdgeInsets.all(kMobilePadding),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/body.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.5), BlendMode.darken),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(kMobilePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- MODIFIED TEXT WIDGET USING RICHTEXT ---
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Experience Premium Living with ',
                      style: baseStyle,
                    ),
                    TextSpan(
                      text: 'Raghunantham', // The word that needs to be golden
                      style: goldenStyle, // Apply the golden style
                    ),
                  ],
                ),
              ),
              // --- END MODIFIED TEXT WIDGET ---

              const SizedBox(height: 25),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGold,
                    foregroundColor: kDarkBackground,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(),
                  ),
                  child: Text(
                    'Book A Tour',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------
// 3. About Section (Playfair Display & Inter)
// ------------------------------------------------
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    // // Define the base style for the main heading (Playfair Display, White)
    // final TextStyle baseHeadingStyle = GoogleFonts.playfairDisplay(
    //   color: Colors.white, 
    //   fontSize: 28, 
    //   fontWeight: FontWeight.bold
    // );

    // // Define the golden style for the specific word (Playfair Display, Gold)
    // final TextStyle goldenHeadingStyle = GoogleFonts.playfairDisplay(
    //   color: kGold, 
    //   fontSize: 28, 
    //   fontWeight: FontWeight.bold
    // );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- MODIFIED HEADING USING RICHTEXT ---
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'About ',
                style: baseHeadingStyle,
              ),
              TextSpan(
                text: 'Raghunantham', // The word that needs to be golden
                style: goldenHeadingStyle, // Apply the golden style
              ),
            ],
          ),
        ),
        // --- END MODIFIED TEXT WIDGET ---

        Container(
          height: 4,
          width: 80,
          margin: const EdgeInsets.only(top: 8, bottom: 20),
        ),
        
        // Inter for body text
        Text(
          'Raghunantham is dedicated to building homes that embody luxury, comfort, and state-of-the-art design. We believe in crafting experiences, not just structures. Our commitment to excellence is reflected in every detail.',
          style: GoogleFonts.inter(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 30),
        
        // Placeholder for the "About" image on the right
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            'assets/about_placeholder.jpg',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 30),
        
        // Statistics are displayed vertically for mobile
        const Wrap(
          spacing: 20.0,
          runSpacing: 25.0,
          children: [
            StatItem(number: '200+', label: 'Happy Clients'),
            StatItem(number: '1000+', label: 'Sq. ft Developed'),
            StatItem(number: '5+', label: 'Years of Experience'),
          ],
        ),
      ],
    );
  }
}

// Assuming StatItem structure is correct and available elsewhere
class StatItem extends StatelessWidget {
  final String number;
  final String label;

  const StatItem({super.key, required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    // Adjusted width calculation for kMobilePadding = 24.0
    double itemWidth = (MediaQuery.of(context).size.width / 2) - kMobilePadding - 10;
    
    return SizedBox(
      width: itemWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number - Uses Playfair Display
          Text(
            number,
            style: GoogleFonts.playfairDisplay(color: kGold, fontSize: 36, fontWeight: FontWeight.w900),
          ),
          // Label - Uses Inter
          Text(
            label,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------
// 4. Vision & Mission Section (Playfair Display & Inter)
// ------------------------------------------------
class VisionMissionSection extends StatelessWidget {
  const VisionMissionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Playfair Display for Heading
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Our ',
                style: GoogleFonts.playfairDisplay(fontSize: 28,fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: 'Vision & Mission', // The word that needs to be golden
                style: GoogleFonts.playfairDisplay(color: kGold,fontSize: 28,fontWeight: FontWeight.bold), // Apply the golden style
              ),
            ],
          ),
        ),
        Container(
          height: 4,
          width: 80,
         // color: kGold,
          margin: const EdgeInsets.only(top: 8, bottom: 30),
        ),
        // Use a Column instead of a Row for better mobile stacking
        const VisionMissionCard(
          icon: Icons.visibility,
          title: 'Our Vision',
          description: 'To be the leading premium real estate developer, recognized for innovation and unparalleled customer satisfaction.',
        ),
        const SizedBox(height: 25),
        const VisionMissionCard(
          icon: Icons.lightbulb,
          title: 'Our Mission',
          description: 'To consistently deliver exceptional properties by maintaining the highest standards of quality, integrity, and ethical practices.',
        ),
      ],
    );
  }
}

class VisionMissionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const VisionMissionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kLighterDark, // Use the defined lighter dark color
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.white12, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kGold, size: 36), // Increased icon size
          const SizedBox(height: 15),
          // Playfair Display for title
          Text(
            title,
            style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Inter for description
          Text(
            description,
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------
// 5. Featured Properties Section (Playfair Display & Inter)
// ------------------------------------------------
class FeaturedPropertiesSection extends StatelessWidget {
  const FeaturedPropertiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    // List of placeholder properties
    final List<Map<String, String>> properties = [
      {'name': 'Bayview Penthouse', 'price': 'Starting at \$2.5 Cr', 'image': 'assets/property1.jpg'},
      {'name': 'Oceanfront Villa', 'price': 'Starting at \$5.7 Cr', 'image': 'assets/property2.jpg'},
      {'name': 'Mountain Retreat', 'price': 'Starting at \$1.8 Cr', 'image': 'assets/property3.jpg'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kSectionSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMobilePadding),
            // Playfair Display for Heading
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Featured ",
                    style: baseHeadingStyle,
                  ),
                  TextSpan(
                    text: "Properties",
                    style: goldenHeadingStyle,
                  )
                ]
              )
              )
          ),
          Container(
            height: 4,
            width: 80,
            //color: kGold,
            margin: const EdgeInsets.only(left: kMobilePadding, top: 8, bottom: 30),
          ),
          // Horizontal ScrollView for properties
          SizedBox(
            height: 330, // Increased height for the horizontal list
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: properties.length,
              itemBuilder: (context, index) {
                return PropertyCard(
                  name: properties[index]['name']!,
                  price: properties[index]['price']!,
                  imagePath: properties[index]['image']!,
                  isFirst: index == 0, // Add left padding to the first item
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final String name;
  final String price;
  final String imagePath;
  final bool isFirst;

  const PropertyCard({
    super.key,
    required this.name,
    required this.price,
    required this.imagePath,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280, // Increased width for each card
      margin: EdgeInsets.only(
        left: isFirst ? kMobilePadding : 15.0, // Ensures first item aligns with padding
        right: 15.0,
      ),
      decoration: BoxDecoration(
        color: kLighterDark, // Use lighter dark background
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            child: Image.asset(
              imagePath, // Placeholder asset
              height: 200, // Increased height
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Playfair Display for name
                Text(
                  name,
                  style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Inter for price
                Text(
                  price,
                  style: GoogleFonts.inter(color: kGold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 35, // Increased button height
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kGold,
                      side: const BorderSide(color: kGold, width: 2), // Bolder border
                      padding: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(),
                    ),
                    // Inter for button text
                    child: Text('View Details', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------
// 6. Why Choose Section (Playfair Display & Inter)
// ------------------------------------------------
class WhyChooseSection extends StatelessWidget {
  const WhyChooseSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {'icon': Icons.security, 'title': 'Verified Listings', 'subtitle': 'Authentic properties, guaranteed.'},
      {'icon': Icons.people, 'title': 'Expert Agency', 'subtitle': 'Experienced and trusted consultants.'},
      {'icon': Icons.location_on, 'title': 'Prime Locations', 'subtitle': 'Handpicked spots for premium living.'},
      {'icon': Icons.construction, 'title': 'R&D Support', 'subtitle': 'Innovation in every project.'},
    ];

    return Container(
      color: kLighterDark,
      padding: const EdgeInsets.symmetric(vertical: kSectionSpacing, horizontal: kMobilePadding),
      child: Column(
        children: [
          // Playfair Display for Heading
          RichText(
            text:TextSpan(
              children: [
                TextSpan(
                  text: "Why Choose ",
                  style: baseHeadingStyle,
                ),
                TextSpan(
                  text: "Raghunantham",
                  style: goldenHeadingStyle
                )
              ]
            ) 
          ),
          Container(
            height: 4,
            width: 80,
            //color: kGold,
            margin: const EdgeInsets.only(top: 8, bottom: 30),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 25.0,
              mainAxisSpacing: 35.0,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              return FeatureItem(
                icon: features[index]['icon']!,
                title: features[index]['title']!,
                subtitle: features[index]['subtitle']!,
              );
            },
          ),
        ],
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureItem({super.key, required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: kDarkBackground,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: kGold.withOpacity(0.5), width: 1),
          ),
          child: Icon(icon, color: kGold, size: 30),
        ),
        const SizedBox(height: 15),
        // Playfair Display for title
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        // Inter for subtitle
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }
}

// ------------------------------------------------
// 7. App Download Section (FIXED COLOR, LAYOUT & Fonts)
// ------------------------------------------------
class AppDownloadSection extends StatelessWidget {
  const AppDownloadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding( 
      padding: const EdgeInsets.symmetric(vertical: kSectionSpacing, horizontal: kMobilePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title (Playfair Display)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Take With ",
                  style: baseHeadingStyle,
                ),
                TextSpan(
                  text: "Raghunantham ",
                  style: goldenHeadingStyle,
                ),
                TextSpan(
                  text: "You ",
                  style: baseHeadingStyle,
                ),
              ]
            )
            ),
          Container(
            height: 4,
            width: 80,
           // color: kGold, // Using correct kGold
            margin: const EdgeInsets.only(top: 8, bottom: 20),
          ),
          
          // Subtitle (Inter)
          Text(
            'Download our app to get real-time property updates and manage your bookings effortlessly from your mobile device.',
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 16),
          ),
          
          const SizedBox(height: 30),
          
          // Mobile phone image
          Center(
            child: Image.asset(
              'assets/app_screenshot.jpg',
              height: 250,
              fit: BoxFit.contain,
            ),
          ),
          
          const SizedBox(height: 30),

          // Buttons: Center aligned and matching size
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placeholder for Google Play button
              Image.asset(
                'assets/google_play_badge.png', 
                height: 90, // Fixed height
              ),
              const SizedBox(width: 15),
              // Placeholder for App Store button
              Image.asset(
                'assets/app_store_badge.png', 
                height: 50, // Fixed height and matching size
              ),
            ],
          ),
          
        ],
      ),
    );
  }
}

// ------------------------------------------------
// 8. Testimonial Section (Playfair Display & Inter)
// ------------------------------------------------
class TestimonialSection extends StatelessWidget {
  const TestimonialSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kLighterDark, // Using kLighterDark
      padding: const EdgeInsets.symmetric(vertical: kSectionSpacing, horizontal: kMobilePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Playfair Display for Heading
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "What Our Clients",
                  style: baseHeadingStyle,
                ),
                TextSpan(
                  text: " Say",
                  style: goldenHeadingStyle,
                ),
              ]
            )
          ),
          Container(
            height: 4,
            width: 80,
            //color: kGold,
            margin: const EdgeInsets.only(top: 8, bottom: 30),
          ),
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: kDarkBackground,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: kGold, size: 24),
                    Icon(Icons.star, color: kGold, size: 24),
                    Icon(Icons.star, color: kGold, size: 24),
                    Icon(Icons.star, color: kGold, size: 24),
                    Icon(Icons.star, color: kGold, size: 24),
                  ],
                ),
                const SizedBox(height: 20),
                // Inter for quote text
                Text(
                  '"Raghunantham exceeded all my expectations. The quality of their construction and the professionalism of their team are unmatched. I finally found my dream home."',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 17, fontStyle: FontStyle.italic, height: 1.5),
                ),
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/client_photo.jpg'),
                ),
                const SizedBox(height: 10),
                // Inter for name and title
                Text(
                  '— Emily A.',
                  style: GoogleFonts.inter(color: kGold, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Satisfied Homeowner',
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------
// 9. Footer Section (Playfair Display & Inter)
// ------------------------------------------------
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kMobilePadding),
      color: const Color(0xFF161616),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Playfair Display for logo
          Text(
            'Raghunantham',
            style: GoogleFonts.playfairDisplay(color: kGold, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          // Social Icons
          Row(
            children: [
              IconButton(icon: const Icon(Icons.facebook, color: Colors.white70, size: 30), onPressed: () {}),
              IconButton(icon: const Icon(Icons.share, color: Colors.white70, size: 30), onPressed: () {}),
              IconButton(icon: const Icon(Icons.camera_alt, color: Colors.white70, size: 30), onPressed: () {}),
            ],
          ),
          const Divider(color: Colors.white12, height: 40),
          // Inter for links
          ...['Home', 'About Us', 'Properties', 'Contact', 'Privacy Policy'].map((title) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              title.toUpperCase(),
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          )),
          const Divider(color: Colors.white12, height: 40),
          // Inter for copyright
          Center(
            child: Text(
              '© ${DateTime.now().year} Raghunantham. ALL RIGHTS RESERVED.',
              style: GoogleFonts.inter(color: Colors.white54, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}