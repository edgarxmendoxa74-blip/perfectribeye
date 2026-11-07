import React from 'react';
import { ShoppingCart } from 'lucide-react';
import { useSiteSettings } from '../hooks/useSiteSettings';

interface HeaderProps {
  cartItemsCount: number;
  onCartClick: () => void;
  onMenuClick: () => void;
}

const Header: React.FC<HeaderProps> = ({ cartItemsCount, onCartClick, onMenuClick }) => {
  const { siteSettings, loading } = useSiteSettings();

  return (
    <header className="sticky top-0 z-50 bg-gradient-to-r from-gray-900 via-gray-800 to-gray-900 backdrop-blur-md border-b border-red-900/30 shadow-lg">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-18 py-2">
          <button 
            onClick={onMenuClick}
            className="flex items-center space-x-3 hover:opacity-90 transition-all duration-200"
          >
            {loading ? (
              <div className="w-12 h-12 bg-gray-700 rounded-lg animate-pulse" />
            ) : (
              <img 
                src={siteSettings?.site_logo || "/ThePerfectRibeyePH_logo.jpg"} 
                alt={siteSettings?.site_name || "The Perfect Ribeye PH"}
                className="w-14 h-14 rounded-lg object-cover shadow-md ring-2 ring-red-700/50"
                onError={(e) => {
                  e.currentTarget.src = "/ThePerfectRibeyePH_logo.jpg";
                }}
              />
            )}
            <div className="flex flex-col items-start">
              <h1 className="text-xl sm:text-2xl font-bold text-white tracking-wide">
                {loading ? (
                  <div className="w-32 h-6 bg-gray-700 rounded animate-pulse" />
                ) : (
                  siteSettings?.site_name || "The Perfect Ribeye PH"
                )}
              </h1>
              <span className="text-xs text-red-400 font-medium tracking-wider hidden sm:block">PREMIUM STEAKS</span>
            </div>
          </button>

          <div className="hidden md:flex items-center space-x-3">
            <button 
              onClick={onCartClick}
              className="relative p-3 text-white hover:text-red-400 bg-gray-800/50 hover:bg-gray-700/70 rounded-full transition-all duration-300 border border-gray-700/50"
            >
              <ShoppingCart className="h-6 w-6" />
              {cartItemsCount > 0 && (
                <span className="absolute -top-1 -right-1 bg-red-600 text-white text-xs font-bold rounded-full h-5 w-5 flex items-center justify-center shadow-lg animate-pulse">
                  {cartItemsCount}
                </span>
              )}
            </button>
          </div>
        </div>
      </div>
    </header>
  );
};

export default Header;