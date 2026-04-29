class MenuItem {
  final int id;
  final String title;
  final String titleAmharic;
  final String description;
  final String descriptionEn;
  final double price;
  final String image;
  final String category;
  final String categoryEn;

  const MenuItem({
    required this.id,
    required this.title,
    required this.titleAmharic,
    required this.description,
    required this.descriptionEn,
    required this.price,
    required this.image,
    required this.category,
    required this.categoryEn,
  });
}

List<MenuItem> getMockFoodMenu() {
  return const [
    MenuItem(
      id: 1, title: 'Tibs', titleAmharic: 'ጥብስ',
      descriptionEn: 'Sliced beef pan-fried in butter, garlic and onion.',
      description: 'በቅቤ፣ ነጭ ሽንኩርት እና ሽንኩርት የተጠበሰ የበሬ ስጋ።',
      price: 150, image: 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?w=400',
      category: 'ስጋ', categoryEn: 'Meat',
    ),
    MenuItem(
      id: 2, title: 'Kitfo', titleAmharic: 'ክትፎ',
      descriptionEn: 'Minced lean beef warmed in spiced butter and mitmita.',
      description: 'ከቀጭን ስጋ የተሰራ፣ በቅቤ እና ሚጥሚጣ የተዘጋጀ።',
      price: 180, image: 'https://images.pexels.com/photos/3535383/pexels-photo-3535383.jpeg?w=400',
      category: 'ስጋ', categoryEn: 'Meat',
    ),
    MenuItem(
      id: 3, title: 'Doro Wot', titleAmharic: 'ዶሮ ወጥ',
      descriptionEn: 'Chicken cooked in spiced butter, onion, chili and berbere with a boiled egg.',
      description: 'በቅቤ፣ ሽንኩርት፣ በርበሬ የተዘጋጀ የዶሮ ወጥ። ከእንቁላል ጋር ይቀርባል።',
      price: 140, image: 'https://images.pexels.com/photos/2338407/pexels-photo-2338407.jpeg?w=400',
      category: 'ወጥ', categoryEn: 'Stew',
    ),
    MenuItem(
      id: 4, title: 'Beyainatu', titleAmharic: 'በያይናቱ',
      descriptionEn: 'Injera topped with colorful vegetables, lentil stews and curries.',
      description: 'ኢንጀራ በአትክልት፣ ምስር ወጥ እና ቅመማ ቅመም ተሸፍኖ ይቀርባል።',
      price: 100, image: 'https://images.pexels.com/photos/1640772/pexels-photo-1640772.jpeg?w=400',
      category: 'የጾም', categoryEn: 'Fasting',
    ),
    MenuItem(
      id: 5, title: 'Shiro', titleAmharic: 'ሽሮ',
      descriptionEn: 'Spiced chickpea puree with butter, served bubbling in a clay pot.',
      description: 'በቅቤ እና ቅመማ ቅመም የተዘጋጀ የሽሮ ወጥ። በሸክላ ድስት ይቀርባል።',
      price: 80, image: 'https://images.pexels.com/photos/4518843/pexels-photo-4518843.jpeg?w=400',
      category: 'የጾም', categoryEn: 'Fasting',
    ),
    MenuItem(
      id: 6, title: 'Fuul', titleAmharic: 'ፉል',
      descriptionEn: 'Stewed spiced fava beans with yogurt, tomato, chili and egg.',
      description: 'የተቀቀለ እና የተቀመመ ባቄላ። ከዮጎርት፣ ቲማቲም እና እንቁላል ጋር ይቀርባል።',
      price: 70, image: 'https://images.pexels.com/photos/5560763/pexels-photo-5560763.jpeg?w=400',
      category: 'ቁርስ', categoryEn: 'Breakfast',
    ),
    MenuItem(
      id: 7, title: 'Enkulal Firfir', titleAmharic: 'እንቁላል ፍርፍር',
      descriptionEn: 'Ethiopian scrambled eggs with spiced butter, peppers, tomatoes and onion.',
      description: 'በኒተር ቅቤ፣ በርበሬ፣ ቲማቲም እና ሽንኩርት የተዘጋጀ እንቁላል ፍርፍር።',
      price: 75, image: 'https://images.pexels.com/photos/1640774/pexels-photo-1640774.jpeg?w=400',
      category: 'ቁርስ', categoryEn: 'Breakfast',
    ),
    MenuItem(
      id: 8, title: 'Fatira', titleAmharic: 'ፋጢራ',
      descriptionEn: 'Thin pastry with scrambled eggs and honey, served with Ethiopian coffee.',
      description: 'ቀጭን ዳቦ ከስክራምብልድ እንቁላል እና ማር ጋር። ከቡና ጋር ይቀርባል።',
      price: 80, image: 'https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg?w=400',
      category: 'ቁርስ', categoryEn: 'Breakfast',
    ),
    MenuItem(
      id: 9, title: 'Dulet', titleAmharic: 'ዱለት',
      descriptionEn: 'Minced tripe, liver and lean beef fried in butter, onion and cardamom.',
      description: 'የተፈጨ ጨጓራ፣ ጉበት እና ቀጭን ስጋ በቅቤ እና ቅመማ ቅመም ተጠብሶ ይቀርባል።',
      price: 130, image: 'https://images.pexels.com/photos/2673353/pexels-photo-2673353.jpeg?w=400',
      category: 'ስጋ', categoryEn: 'Meat',
    ),
    MenuItem(
      id: 10, title: "Ti'hilo", titleAmharic: 'ጥሒሎ',
      descriptionEn: 'Barley balls dipped in spiced pulse sauce. A Tigray specialty.',
      description: 'የገብስ ኳሶች በቅመማ ቅመም ወጥ ውስጥ ይነከራሉ። የትግራይ ልዩ ምግብ።',
      price: 120, image: 'https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg?w=400',
      category: 'ወጥ', categoryEn: 'Stew',
    ),
    MenuItem(
      id: 11, title: 'Tere Siga', titleAmharic: 'ጥሬ ስጋ',
      descriptionEn: 'Cubes of raw red meat eaten with injera, dipped in mitmita spice.',
      description: 'ጥሬ ቀይ ስጋ ቁርጥራጮች። ከኢንጀራ ጋር ይቀርባል፣ ከሚጥሚጣ ጋር ይነከራል።',
      price: 200, image: 'https://images.pexels.com/photos/3997609/pexels-photo-3997609.jpeg?w=400',
      category: 'ስጋ', categoryEn: 'Meat',
    ),
    MenuItem(
      id: 12, title: 'Asa (Fish)', titleAmharic: 'አሳ',
      descriptionEn: 'Whole fried Nile perch served with injera and spicy dipping sauce.',
      description: 'ሙሉ የናይል ፐርች ዓሳ ተጠብሶ ይቀርባል። ከኢንጀራ እና ቅመማ ወጥ ጋር ይበላል።',
      price: 160, image: 'https://images.pexels.com/photos/3296279/pexels-photo-3296279.jpeg?w=400',
      category: 'ዓሳ', categoryEn: 'Fish',
    ),
    MenuItem(
      id: 13, title: 'Spriss', titleAmharic: 'ስፕሪስ',
      descriptionEn: 'Layered juice from three fruits — no water, no sugar. Topped with fresh lime.',
      description: 'ከሶስት ፍራፍሬ የተሰራ ንብርብር ጭማቂ። ስኳር ወይም ውሃ የለም። ከሎሚ ጋር ይቀርባል።',
      price: 60, image: 'https://images.pexels.com/photos/1132558/pexels-photo-1132558.jpeg?w=400',
      category: 'መጠጥ', categoryEn: 'Drinks',
    ),
    MenuItem(
      id: 14, title: 'Pasta beu Injera', titleAmharic: 'ፓስታ በኡ ኢንጀራ',
      descriptionEn: 'Ethiopian-Italian fusion: pasta served in the center of injera, eaten by hand.',
      description: 'ፓስታ በኢንጀራ መሃል ላይ ይቀርባል። የጣሊያን እና የኢትዮጵያ ምግብ ጥምረት።',
      price: 90, image: 'https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg?w=400',
      category: 'ፓስታ', categoryEn: 'Pasta',
    ),
    MenuItem(
      id: 15, title: 'Ethiopian Coffee', titleAmharic: 'የኢትዮጵያ ቡና',
      descriptionEn: 'Traditional Ethiopian coffee ceremony served with popcorn.',
      description: 'ባህላዊ የኢትዮጵያ ቡና ሥነ ሥርዓት ከጠጠር ጋር ይቀርባል።',
      price: 60, image: 'https://images.pexels.com/photos/302899/pexels-photo-302899.jpeg?w=400',
      category: 'መጠጥ', categoryEn: 'Drinks',
    ),
  ];
}
