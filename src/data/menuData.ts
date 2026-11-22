import { MenuItem } from '../types';

export interface DefaultCategory {
  id: string;
  name: string;
  icon: string;
  sort_order: number;
  active: boolean;
  created_at: string;
  updated_at: string;
}

export const defaultCategories: DefaultCategory[] = [
  { id: 'australian-beef', name: 'Australian Beef', icon: '🇦🇺', sort_order: 1, active: true, created_at: '', updated_at: '' },
  { id: 'australian-striploin', name: 'Australian Marbled Striploin', icon: '🥩', sort_order: 2, active: true, created_at: '', updated_at: '' },
  { id: 'australian-ribeye', name: 'Australian Ribeye', icon: '🇦🇺', sort_order: 3, active: true, created_at: '', updated_at: '' },
  { id: 'japanese-wagyu', name: 'Japanese Wagyu', icon: '🇯🇵', sort_order: 4, active: true, created_at: '', updated_at: '' },
  { id: 'usda-ribeye', name: 'USDA / USA Ribeye', icon: '🇺🇸', sort_order: 5, active: true, created_at: '', updated_at: '' },
  { id: 'wagyu-cubes', name: 'Wagyu Cubes', icon: '🎲', sort_order: 6, active: true, created_at: '', updated_at: '' },
];

export const addOnCategories = ['Butter', 'Sauces', 'Sides', 'Extras'];

export const menuData: MenuItem[] = [
  // 1. Australian Beef
  {
    id: 'aus-marbled-ribeye-beef',
    name: 'AUS Marbled Ribeye',
    description: 'Premium Australian marbled ribeye steak with excellent fat distribution. Rich, buttery flavor perfect for grilling. Sold per kilo.',
    basePrice: 1450,
    category: 'australian-beef',
    popular: true,
    available: true,
    image: '/s4.jpg',
    variations: [
      { id: 'var-1', name: '500g Cut', price: 0 },
      { id: 'var-2', name: '1kg Cut', price: 0 }
    ],
    addOns: [
      { id: 'add-1', name: 'Truffle Butter', price: 120, category: 'Butter' },
      { id: 'add-2', name: 'Red Wine Demi-Glace Sauce', price: 95, category: 'Sauces' }
    ]
  },
  // 2. Australian Marbled Striploin
  {
    id: 'aus-marbled-striploin',
    name: 'AUS Marbled Striploin',
    description: 'Premium Australian marbled striploin cut. Tender and flavorful with beautiful marbling throughout. Sold per kilo.',
    basePrice: 1450,
    category: 'australian-striploin',
    popular: true,
    available: true,
    image: '/s1.jpg'
  },
  // 3. Australian Ribeye
  {
    id: 'aus-marbled-ribeye',
    name: 'AUS Marbled Ribeye',
    description: 'Premium Australian marbled ribeye with excellent marbling. Juicy and flavorful, perfect for any cooking method. Sold per kilo.',
    basePrice: 1450,
    category: 'australian-ribeye',
    popular: true,
    available: true,
    image: '/s4.jpg',
    variations: [
      { id: 'var-3', name: '500g Cut', price: 0 },
      { id: 'var-4', name: '1kg Cut', price: 0 }
    ],
    addOns: [
      { id: 'add-3', name: 'Truffle Butter', price: 120, category: 'Butter' },
      { id: 'add-4', name: 'Red Wine Demi-Glace Sauce', price: 95, category: 'Sauces' }
    ]
  },
  {
    id: 'aus-giant-marbled-ribeye',
    name: 'AUS Giant Marbled Ribeye',
    description: 'Extra-large Australian marbled ribeye cut. Perfect for sharing or special occasions. Premium quality with exceptional marbling. Sold per kilo.',
    basePrice: 1450,
    category: 'australian-ribeye',
    popular: true,
    available: true,
    image: '/s6.jpg'
  },
  {
    id: 'aus-artisan-ribeye',
    name: 'AUS Artisan Ribeye',
    description: 'Artisan-grade Australian ribeye, hand-selected for superior quality. Exceptional tenderness and rich beef flavor. Sold per kilo.',
    basePrice: 1650,
    category: 'australian-ribeye',
    popular: false,
    available: true,
    image: '/s2.jpg'
  },
  {
    id: 'premium-australian-ribeye',
    name: 'Premium Australian Ribeye',
    description: 'Top-tier Australian ribeye with wagyu-level marbling. The ultimate steak experience with melt-in-your-mouth texture. Sold per kilo.',
    basePrice: 1999,
    category: 'australian-ribeye',
    popular: true,
    available: true,
    image: '/s8.jpg'
  },
  // 4. Japanese Wagyu
  {
    id: 'japanese-wagyu-cubes',
    name: 'Japanese Wagyu Cubes',
    description: 'Authentic Japanese Wagyu beef cubes. Incredibly marbled with signature buttery texture. Perfect for sukiyaki, yakiniku, or pan-searing. Sold per kilo.',
    basePrice: 1250,
    category: 'japanese-wagyu',
    popular: true,
    available: true,
    image: '/s3.jpg'
  },
  // 5. USDA Ribeye
  {
    id: 'all-grilled-ribeye',
    name: 'All Grilled Ribeye',
    description: 'Classic USDA grilled ribeye, perfect char and seasoning. A steakhouse favorite at home. Sold per kilo.',
    basePrice: 1399,
    category: 'usda-ribeye',
    popular: false,
    available: true,
    image: '/s5.jpg'
  },
  {
    id: 'usda-ribeye-hq',
    name: 'USDA Ribeye (High Quality)',
    description: 'High quality USDA ribeye with excellent fat content. Rich, beefy flavor with perfect marbling. Sold per kilo.',
    basePrice: 1399,
    category: 'usda-ribeye',
    popular: true,
    available: true,
    image: '/s7.jpg'
  },
  {
    id: 'usda-tender-ribeye',
    name: 'USDA Tender Ribeye',
    description: 'USDA certified tender ribeye, known for its exceptional tenderness and juicy flavor. A customer favorite. Sold per kilo.',
    basePrice: 1399,
    category: 'usda-ribeye',
    popular: true,
    available: true,
    image: '/s7.jpg'
  },
  {
    id: 'usa-ribeye-mighty',
    name: 'USA Ribeye (Mighty Cuts)',
    description: 'Premium USA ribeye with mighty large portions. Thick cuts with impressive marbling and bold American beef flavor. Sold per kilo.',
    basePrice: 1450,
    category: 'usda-ribeye',
    popular: false,
    available: true,
    image: '/s6.jpg'
  },
  {
    id: 'usa-ribeye-artisan',
    name: 'USA Ribeye',
    description: 'Premium USA ribeye with artisan-level quality. Hand-selected for optimal flavor and tenderness. Sold per kilo.',
    basePrice: 1650,
    category: 'usda-ribeye',
    popular: false,
    available: true,
    image: '/s2.jpg'
  },
  {
    id: 'usa-ribeye-wagyu',
    name: 'USA Ribeye (Wagyu Cuts)',
    description: 'Premium USA ribeye featuring wagyu-style cuts. Exceptional marbling rivaling true wagyu beef. Sold per kilo.',
    basePrice: 1999,
    category: 'usda-ribeye',
    popular: true,
    available: true,
    image: '/s8.jpg'
  },
  // 6. Wagyu Cubes
  {
    id: 'wagyu-cubes-category',
    name: 'Japanese Wagyu Cubes',
    description: 'Premium Japanese Wagyu beef cut into perfect cubes. Ideal for hot pot, stir-fry, or teppanyaki. Exceptional marbling and melt-in-your-mouth texture. Sold per kilo.',
    basePrice: 1250,
    category: 'wagyu-cubes',
    popular: true,
    available: true,
    image: '/s3.jpg'
  }
];
