module.exports = {
    important: true,
    prefix: "tw-",
    purge: {
      content: ["./src/**/*.vue"]
    },
    theme: {
      extend: {
        colors: {
          psprimary: {
            DEFAULT: "#25b9d7"
          },
          pspink: {
            DEFAULT: "#DB126E"
          },
          psorange: {
            DEFAULT: "#FABF73"
          }
        }
      },
      screens: {
        sm: "640px",
        // => @media (min-width: 640px) { ... }
  
        md: "768px",
        // => @media (min-width: 768px) { ... }
  
        lg: "1024px",
        // => @media (min-width: 1024px) { ... }
  
        xl: "1280px",
        // => @media (min-width: 1280px) { ... }
  
        "2xl": "1536px"
        // => @media (min-width: 1536px) { ... }
      }
    }
  };
  