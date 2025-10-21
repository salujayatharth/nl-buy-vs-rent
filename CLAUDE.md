# Claude AI Assistant - Project Guide

This document provides guidance for Claude AI when working on the Netherlands Rent vs. Buy Calculator project.

## Project Overview

This is a web-based financial calculator specifically designed for the Dutch housing market. It helps users make informed decisions about whether to rent or buy property in the Netherlands by modeling both scenarios with Dutch-specific tax considerations, visualizations, and comprehensive financial projections.

## Tech Stack

- **Frontend**: Vanilla JavaScript (ES6+), HTML5, CSS3
- **Styling**: Tailwind CSS (via CDN)
- **Charts**: Chart.js (via CDN)
- **Storage**: Browser Local Storage API
- **No Build Process**: Pure static files, no bundler or transpilation

## Key Features

1. **Real-time Financial Calculations**
   - Buying scenario: mortgage, property appreciation, tax benefits
   - Renting scenario: investment growth, wealth accumulation

2. **Netherlands-Specific Considerations**
   - Mortgage interest deduction (hypotheekrenteaftrek)
   - Box 3 wealth tax on investments
   - Property tax (OZB) and VvE fees
   - Dutch tax brackets and marginal rates

3. **Interactive Visualizations**
   - Chart.js powered comparison charts
   - Yearly data tables with CSV export
   - Responsive design for all devices

## Project Structure

```
/
├── index.html          # Main application file (single-page app)
├── styles.css          # Custom styles (if any, mostly Tailwind)
├── script.js           # Core calculation and UI logic
├── README.md           # Project documentation
├── LICENSE             # MIT License
└── CLAUDE.md           # This file
```

## Development Guidelines

### Code Style
- Use modern JavaScript (ES6+) features
- Maintain vanilla JS approach (no frameworks)
- Keep code readable and well-commented
- Follow existing naming conventions
- Ensure mobile-first responsive design

### Testing Approach
- Manual testing in multiple browsers (Chrome, Firefox, Safari)
- Test on mobile devices for responsive behavior
- Verify calculations with example scenarios
- Check Local Storage persistence

### Common Tasks

#### Adding New Input Parameters
1. Add HTML input element in `index.html`
2. Add event listener in JavaScript
3. Update calculation functions
4. Update Local Storage save/load logic
5. Test with various input values

#### Modifying Calculations
1. Locate calculation functions in `script.js`
2. Update formulas with Dutch tax/financial rules
3. Verify with real-world examples
4. Update documentation if needed

#### Updating Charts
1. Find Chart.js configuration
2. Modify data preparation functions
3. Test chart rendering and interactions
4. Ensure mobile responsiveness

### Dutch Financial Context

When working on calculations, be aware of:
- **Tax rates**: Netherlands has progressive income tax (Box 1)
- **Box 3 tax**: Wealth tax on assets > €57,000 (2024 threshold)
- **Mortgage interest**: Deductible from taxable income
- **Property tax**: Varies by municipality (OZB)
- **VvE fees**: Monthly fees for apartment buildings
- **Transfer tax**: 2% for properties (10.4% for investors)

### Important Considerations

1. **Accuracy**: Financial calculations must be precise and based on current Dutch regulations
2. **User Experience**: Changes should maintain or improve the intuitive interface
3. **Performance**: Keep the app lightweight and fast
4. **Accessibility**: Maintain ARIA labels and keyboard navigation
5. **Browser Compatibility**: Test in all major browsers

## Git Workflow

- Main branch: `main`
- Feature branches: Use descriptive names (e.g., `feature/add-inflation-modeling`)
- Claude-generated branches: Prefix with `claude/`
- Commit messages: Clear, descriptive, explaining the "why"

## Testing Checklist

Before committing changes:
- [ ] Calculator produces accurate results
- [ ] Charts render correctly
- [ ] Responsive design works on mobile
- [ ] Local Storage saves/loads properly
- [ ] No console errors
- [ ] Code follows project conventions
- [ ] Comments/documentation updated if needed

## Useful Resources

- [Belastingdienst (Dutch Tax Authority)](https://www.belastingdienst.nl/)
- [Chart.js Documentation](https://www.chartjs.org/docs/)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [MDN Web Docs](https://developer.mozilla.org/)

## Common Issues and Solutions

### Issue: Charts not updating
- Check data preparation functions
- Verify Chart.js instance is properly updated
- Ensure chart.update() is called after data changes

### Issue: Local Storage not persisting
- Check browser privacy settings
- Verify JSON serialization/deserialization
- Test in incognito mode for privacy-related issues

### Issue: Calculation discrepancies
- Double-check Dutch tax formulas
- Verify rounding behavior
- Test edge cases (zero values, very large numbers)

## Contact

**Project Maintainer**: Yatharth Saluja ([@salujayatharth](https://github.com/salujayatharth))

**Live Demo**: [https://salujayatharth.github.io/nl-buy-vs-rent/](https://salujayatharth.github.io/nl-buy-vs-rent/)

---

*This document helps Claude AI understand the project context and provide better assistance. Last updated: 2025-10-21*
