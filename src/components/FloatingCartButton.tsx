import React from 'react';
import { ShoppingCart } from 'lucide-react';

interface FloatingCartButtonProps {
  itemCount: number;
  onCartClick: () => void;
}

const FloatingCartButton: React.FC<FloatingCartButtonProps> = ({ itemCount, onCartClick }) => {
  if (itemCount === 0) return null;

  return (
    <button
      onClick={onCartClick}
      className="fixed bottom-6 right-6 bg-gradient-to-r from-red-700 to-red-800 text-white p-4 rounded-full shadow-2xl shadow-red-900/40 hover:from-red-800 hover:to-red-900 transition-all duration-300 transform hover:scale-110 z-40 md:hidden border border-red-600/30"
    >
      <div className="relative">
        <ShoppingCart className="h-6 w-6" />
        <span className="absolute -top-2 -right-2 bg-amber-400 text-gray-900 text-xs rounded-full h-5 w-5 flex items-center justify-center font-bold shadow-lg">
          {itemCount}
        </span>
      </div>
    </button>
  );
};

export default FloatingCartButton;