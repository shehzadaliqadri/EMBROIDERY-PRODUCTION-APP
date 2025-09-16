# Embroidery Production App

A comprehensive embroidery production management system with React components for data entry and tracking.

## Project Structure

```
EMBROIDERY-PRODUCTION-APP/
├── database/
│   ├── schema.sql              # Database structure
│   └── sample_queries.sql      # Example queries
├── frontend/
│   ├── ProductionEntryForm.jsx # React component for production data entry
│   └── ProductionEntryForm.css # Styling for the form component
├── .gitignore
└── README.md
```

## Frontend Components

### ProductionEntryForm Component

A React form component for entering embroidery production data with the following fields:

- **Date**: Production date (date picker)
- **Operator**: Name of the machine operator (text input)
- **Helper**: Name of the helper (text input)
- **Shift**: Work shift selection (dropdown: N/D for Night/Day)
- **Design No**: Design identification number (text input)
- **Design Stitch**: Number of stitches in the design (numeric input)
- **CR/BL/RD**: Color type selection (dropdown: CR, BL, RD)

#### Features

- ✅ Comprehensive form validation
- ✅ Real-time error feedback
- ✅ Responsive design (mobile-friendly)
- ✅ Accessible form controls
- ✅ Modern, professional styling
- ✅ Form reset functionality
- ✅ Submit handling with console logging

## Getting Started

### Prerequisites

- Node.js (v14 or higher)
- npm or yarn
- React (v17 or higher)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/shehzadaliqadri/EMBROIDERY-PRODUCTION-APP.git
cd EMBROIDERY-PRODUCTION-APP
```

2. Install dependencies:
```bash
npm install
# or
yarn install
```

3. Install React and React DOM (if not already installed):
```bash
npm install react react-dom
# or
yarn add react react-dom
```

### Using the ProductionEntryForm Component

1. **Import the component** in your React application:
```jsx
import ProductionEntryForm from './frontend/ProductionEntryForm';
```

2. **Include the component** in your JSX:
```jsx
function App() {
  return (
    <div className="App">
      <ProductionEntryForm />
    </div>
  );
}
```

3. **Ensure CSS is loaded** by importing the stylesheet:
```jsx
import './frontend/ProductionEntryForm.css';
```

### Running the Component

If you're using Create React App or a similar setup:

```bash
npm start
# or
yarn start
```

### Form Validation Rules

- All fields are required
- Design Stitch must be a positive number
- Date must be selected
- Dropdown selections must be made from available options

### Customization

The component can be customized by:

1. **Styling**: Modify `ProductionEntryForm.css` to change appearance
2. **Validation**: Update validation rules in the `validateForm()` function
3. **Submission**: Modify the `handleSubmit()` function to integrate with your backend
4. **Fields**: Add or remove form fields as needed in the component JSX

### Backend Integration

To integrate with a backend system:

1. Update the `handleSubmit` function in `ProductionEntryForm.jsx`
2. Replace the `console.log` and `alert` with API calls:

```jsx
const handleSubmit = async (e) => {
  e.preventDefault();
  
  if (validateForm()) {
    try {
      const response = await fetch('/api/production-entries', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
      });
      
      if (response.ok) {
        alert('Production entry submitted successfully!');
        setFormData({
          date: '',
          operator: '',
          helper: '',
          shift: '',
          designNo: '',
          designStitch: '',
          colorType: ''
        });
      } else {
        alert('Error submitting entry. Please try again.');
      }
    } catch (error) {
      console.error('Error:', error);
      alert('Error submitting entry. Please try again.');
    }
  }
};
```

## Database Integration

The `database/` folder contains:

- `schema.sql`: Database table structure for storing production data
- `sample_queries.sql`: Example SQL queries for common operations

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions or issues, please open an issue on the GitHub repository.

---

**Built with ❤️ for embroidery production management**