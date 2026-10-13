import React, { useEffect, useState, useRef } from 'react';

const LandingPage: React.FC = () => {
  const [visibleSections, setVisibleSections] = useState<Set<number>>(new Set([0]));
  const containerRef = useRef<HTMLDivElement>(null);

  const sections = [
    {
      id: 'hero',
      bgImage: '/hero-bg-1.jpg',
      badge: '🚚 FREE DELIVERY within Metro Manila',
      title: 'Premium Imported Steaks',
      subtitle: 'SAME DAY DELIVERY • NO MINIMUM ORDER',
      description: 'Experience restaurant-quality steaks delivered fresh to your doorstep',
      showCTA: true,
    },
    {
      id: 'nationwide',
      bgImage: '/hero-bg-2.jpg',
      badge: '🇵🇭 Nationwide Delivery',
      title: 'We Supply Imported Steaks',
      subtitle: 'LUZON • VISAYAS • MINDANAO',
      description: 'Premium beef cuts delivered anywhere in the Philippines',
      showCTA: false,
    },
    {
      id: 'precision',
      bgImage: '/hero-bg-3.jpg',
      badge: '⭐ Premium Quality',
      title: 'Handled with Precision',
      subtitle: '',
      description: "Delivering steaks worthy of the world's best kitchens",
      showCTA: false,
    },
    {
      id: 'trusted',
      bgImage: '/hero-bg-2.jpg',
      badge: '👨‍🍳 Professional Grade',
      title: 'Trusted by Chefs',
      subtitle: 'Chosen by Professionals',
      description: 'Join hundreds of restaurants and home cooks who trust our premium quality',
      showCTA: false,
    },
  ];

  // Use Intersection Observer for better scroll detection
  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          const index = parseInt(entry.target.getAttribute('data-index') || '0');
          setVisibleSections((prev) => {
            const newSet = new Set(prev);
            if (entry.isIntersecting) {
              newSet.add(index);
            }
            return newSet;
          });
        });
      },
      {
        threshold: 0.5, // Trigger when 50% of section is visible
        root: containerRef.current,
      }
    );

    // Observe all sections
    const sectionElements = document.querySelectorAll('.landing-section');
    sectionElements.forEach((section) => observer.observe(section));

    return () => observer.disconnect();
  }, []);

  const scrollToMenu = () => {
    const menuSection = document.getElementById('menu');
    if (menuSection) {
      menuSection.scrollIntoView({ behavior: 'smooth' });
    }
  };


  return (
    <>
      {/* Announcement Bar (Floating) */}
      <div className="fixed top-16 left-0 right-0 z-30 bg-gradient-to-r from-red-700 via-red-600 to-red-700 text-white py-2 overflow-hidden">
        <div className="animate-marquee whitespace-nowrap flex items-center">
          <span className="mx-8 text-sm font-medium">🚚 FREE DELIVERY within Metro Manila</span>
          <span className="mx-8 text-sm font-medium">⚡ SAME DAY DELIVERY</span>
          <span className="mx-8 text-sm font-medium">📦 NO MINIMUM ORDER</span>
          <span className="mx-8 text-sm font-medium">🇵🇭 Nationwide Shipping Available</span>
          <span className="mx-8 text-sm font-medium">🚚 FREE DELIVERY within Metro Manila</span>
          <span className="mx-8 text-sm font-medium">⚡ SAME DAY DELIVERY</span>
          <span className="mx-8 text-sm font-medium">📦 NO MINIMUM ORDER</span>
          <span className="mx-8 text-sm font-medium">🇵🇭 Nationwide Shipping Available</span>
        </div>
      </div>

      {/* Landing Sections */}
      <div ref={containerRef} className="relative">
        {sections.map((section, index) => {
          const isVisible = visibleSections.has(index);
          
          return (
            <section
              key={section.id}
              data-index={index}
              className="landing-section relative h-screen w-full flex items-center justify-center overflow-hidden"
            >
              {/* Background Image */}
              <div 
                className="absolute inset-0 bg-cover bg-center bg-no-repeat transition-transform duration-1000"
                style={{
                  backgroundImage: `url(${section.bgImage})`,
                  transform: isVisible ? 'scale(1.05)' : 'scale(1)',
                }}
              />
              
              {/* Dark Overlay */}
              <div className="absolute inset-0 bg-gradient-to-b from-black/60 via-black/40 to-black/70" />
              
              {/* Content - Always visible with animations */}
              <div className="relative z-10 text-center px-4 max-w-5xl mx-auto pt-20">
                {/* Badge */}
                <div 
                  className={`inline-block mb-6 transition-all duration-700 ${
                    isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'
                  }`}
                >
                  <span className="bg-red-600/90 backdrop-blur-sm text-white px-6 py-2 rounded-full text-sm md:text-base font-medium shadow-lg">
                    {section.badge}
                  </span>
                </div>

                {/* Title */}
                <h1 
                  className={`text-4xl md:text-6xl lg:text-7xl font-bold text-white mb-4 tracking-tight transition-all duration-700 delay-100 ${
                    isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'
                  }`}
                  style={{ transitionDelay: '100ms' }}
                >
                  {section.title}
                </h1>

                {/* Subtitle */}
                {section.subtitle && (
                  <p 
                    className={`text-xl md:text-3xl lg:text-4xl font-bold text-red-500 mb-6 tracking-wide transition-all duration-700 ${
                      isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'
                    }`}
                    style={{ transitionDelay: '200ms' }}
                  >
                    {section.subtitle}
                  </p>
                )}

                {/* Description */}
                <p 
                  className={`text-lg md:text-xl text-gray-300 mb-8 max-w-2xl mx-auto transition-all duration-700 ${
                    isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'
                  }`}
                  style={{ transitionDelay: '300ms' }}
                >
                  {section.description}
                </p>

                {/* CTA Button */}
                {section.showCTA && (
                  <button 
                    onClick={scrollToMenu}
                    className={`bg-gradient-to-r from-red-700 to-red-600 text-white px-8 py-4 rounded-full text-lg font-semibold hover:from-red-600 hover:to-red-500 transition-all duration-500 transform hover:scale-105 shadow-xl shadow-red-900/30 ${
                      isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'
                    }`}
                    style={{ transitionDelay: '400ms' }}
                  >
                    🥩 View Our Steaks
                  </button>
                )}
              </div>


            </section>
          );
        })}
      </div>
    </>
  );
};

export default LandingPage;
