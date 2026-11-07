import React, { useRef, useState, useEffect } from 'react';
import { useCategories } from '../hooks/useCategories';

interface SubNavProps {
  selectedCategory: string;
  onCategoryClick: (categoryId: string) => void;
}

const SubNav: React.FC<SubNavProps> = ({ selectedCategory, onCategoryClick }) => {
  const { categories, loading } = useCategories();
  const scrollRef = useRef<HTMLDivElement>(null);
  const [showLeftArrow, setShowLeftArrow] = useState(false);
  const [showRightArrow, setShowRightArrow] = useState(false);

  // Check scroll position to show/hide arrows
  const checkScroll = () => {
    const el = scrollRef.current;
    if (el) {
      setShowLeftArrow(el.scrollLeft > 0);
      setShowRightArrow(el.scrollLeft < el.scrollWidth - el.clientWidth - 5);
    }
  };

  useEffect(() => {
    checkScroll();
    const el = scrollRef.current;
    if (el) {
      el.addEventListener('scroll', checkScroll);
      window.addEventListener('resize', checkScroll);
      
      // Handle mouse wheel to scroll horizontally
      const handleWheel = (e: WheelEvent) => {
        if (el.scrollWidth > el.clientWidth) {
          e.preventDefault();
          el.scrollLeft += e.deltaY;
          checkScroll();
        }
      };
      
      el.addEventListener('wheel', handleWheel, { passive: false });
      
      return () => {
        el.removeEventListener('scroll', checkScroll);
        window.removeEventListener('resize', checkScroll);
        el.removeEventListener('wheel', handleWheel);
      };
    }
  }, [categories]);

  const scroll = (direction: 'left' | 'right') => {
    const el = scrollRef.current;
    if (el) {
      const scrollAmount = 200;
      el.scrollBy({
        left: direction === 'left' ? -scrollAmount : scrollAmount,
        behavior: 'smooth'
      });
    }
  };

  return (
    <div className="sticky top-[72px] z-40 bg-gray-900/95 backdrop-blur-md border-b border-red-900/30">
      <div className="max-w-7xl mx-auto px-2 sm:px-4 lg:px-8 relative">
        {/* Left scroll arrow */}
        {showLeftArrow && (
          <button
            onClick={() => scroll('left')}
            className="absolute left-0 top-1/2 -translate-y-1/2 z-10 bg-gradient-to-r from-gray-900 via-gray-900/95 to-transparent pl-2 pr-6 py-4 text-white hover:text-red-500 transition-colors"
            aria-label="Scroll left"
          >
            <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
            </svg>
          </button>
        )}

        {/* Horizontal scrollable filter container */}
        <div 
          ref={scrollRef}
          className="flex items-center gap-2 sm:gap-3 overflow-x-auto py-3 scrollbar-hide scroll-smooth px-1"
          style={{
            WebkitOverflowScrolling: 'touch',
          }}
        >
          {loading ? (
            <div className="flex gap-2 sm:gap-3">
              {[1,2,3,4,5].map(i => (
                <div key={i} className="h-9 w-24 bg-gray-800 rounded-full animate-pulse flex-shrink-0" />
              ))}
            </div>
          ) : (
            <>
              <button
                onClick={() => onCategoryClick('all')}
                className={`flex-shrink-0 px-3 sm:px-4 py-2 rounded-full text-xs sm:text-sm font-medium transition-all duration-300 border whitespace-nowrap ${
                  selectedCategory === 'all'
                    ? 'bg-gradient-to-r from-red-700 to-red-600 text-white border-red-600 shadow-lg shadow-red-900/30'
                    : 'bg-gray-800/50 text-gray-300 border-gray-700 hover:border-red-700 hover:text-white'
                }`}
              >
                All
              </button>
              {categories.map((c) => (
                <button
                  key={c.id}
                  onClick={() => onCategoryClick(c.id)}
                  className={`flex-shrink-0 px-3 sm:px-4 py-2 rounded-full text-xs sm:text-sm font-medium transition-all duration-300 border flex items-center gap-1 sm:gap-2 whitespace-nowrap ${
                    selectedCategory === c.id
                      ? 'bg-gradient-to-r from-red-700 to-red-600 text-white border-red-600 shadow-lg shadow-red-900/30'
                      : 'bg-gray-800/50 text-gray-300 border-gray-700 hover:border-red-700 hover:text-white'
                  }`}
                >
                  <span>{c.icon}</span>
                  <span>{c.name}</span>
                </button>
              ))}
            </>
          )}
        </div>

        {/* Right scroll arrow */}
        {showRightArrow && (
          <button
            onClick={() => scroll('right')}
            className="absolute right-0 top-1/2 -translate-y-1/2 z-10 bg-gradient-to-l from-gray-900 via-gray-900/95 to-transparent pr-2 pl-6 py-4 text-white hover:text-red-500 transition-colors"
            aria-label="Scroll right"
          >
            <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
            </svg>
          </button>
        )}
      </div>
    </div>
  );
};

export default SubNav;


