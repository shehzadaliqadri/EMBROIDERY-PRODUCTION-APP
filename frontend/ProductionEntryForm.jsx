import React, { useState } from 'react';
import './ProductionEntryForm.css';

const ProductionEntryForm = () => {
  const [formData, setFormData] = useState({
    date: '',
    operator: '',
    helper: '',
    shift: '',
    designNo: '',
    designStitch: '',
    colorType: ''
  });

  const [errors, setErrors] = useState({});

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
    
    // Clear error when user starts typing
    if (errors[name]) {
      setErrors(prev => ({
        ...prev,
        [name]: ''
      }));
    }
  };

  const validateForm = () => {
    const newErrors = {};

    if (!formData.date.trim()) {
      newErrors.date = 'Date is required';
    }

    if (!formData.operator.trim()) {
      newErrors.operator = 'Operator name is required';
    }

    if (!formData.helper.trim()) {
      newErrors.helper = 'Helper name is required';
    }

    if (!formData.shift) {
      newErrors.shift = 'Shift selection is required';
    }

    if (!formData.designNo.trim()) {
      newErrors.designNo = 'Design number is required';
    }

    if (!formData.designStitch.trim()) {
      newErrors.designStitch = 'Design stitch count is required';
    } else if (isNaN(formData.designStitch) || Number(formData.designStitch) <= 0) {
      newErrors.designStitch = 'Design stitch must be a positive number';
    }

    if (!formData.colorType) {
      newErrors.colorType = 'Color type selection is required';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    
    if (validateForm()) {
      console.log('Form submitted successfully:', formData);
      // Here you would typically send the data to your backend
      alert('Production entry submitted successfully!');
      
      // Reset form after successful submission
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
      alert('Please fix the validation errors before submitting.');
    }
  };

  const handleReset = () => {
    setFormData({
      date: '',
      operator: '',
      helper: '',
      shift: '',
      designNo: '',
      designStitch: '',
      colorType: ''
    });
    setErrors({});
  };

  return (
    <div className="production-entry-form">
      <div className="form-container">
        <h2 className="form-title">Production Entry Form</h2>
        <form onSubmit={handleSubmit} className="form">
          <div className="form-row">
            <div className="form-group">
              <label htmlFor="date" className="form-label">
                Date *
              </label>
              <input
                type="date"
                id="date"
                name="date"
                value={formData.date}
                onChange={handleInputChange}
                className={`form-input ${errors.date ? 'error' : ''}`}
                required
              />
              {errors.date && <span className="error-message">{errors.date}</span>}
            </div>

            <div className="form-group">
              <label htmlFor="shift" className="form-label">
                Shift *
              </label>
              <select
                id="shift"
                name="shift"
                value={formData.shift}
                onChange={handleInputChange}
                className={`form-select ${errors.shift ? 'error' : ''}`}
                required
              >
                <option value="">Select Shift</option>
                <option value="N">Night (N)</option>
                <option value="D">Day (D)</option>
              </select>
              {errors.shift && <span className="error-message">{errors.shift}</span>}
            </div>
          </div>

          <div className="form-row">
            <div className="form-group">
              <label htmlFor="operator" className="form-label">
                Operator *
              </label>
              <input
                type="text"
                id="operator"
                name="operator"
                value={formData.operator}
                onChange={handleInputChange}
                className={`form-input ${errors.operator ? 'error' : ''}`}
                placeholder="Enter operator name"
                required
              />
              {errors.operator && <span className="error-message">{errors.operator}</span>}
            </div>

            <div className="form-group">
              <label htmlFor="helper" className="form-label">
                Helper *
              </label>
              <input
                type="text"
                id="helper"
                name="helper"
                value={formData.helper}
                onChange={handleInputChange}
                className={`form-input ${errors.helper ? 'error' : ''}`}
                placeholder="Enter helper name"
                required
              />
              {errors.helper && <span className="error-message">{errors.helper}</span>}
            </div>
          </div>

          <div className="form-row">
            <div className="form-group">
              <label htmlFor="designNo" className="form-label">
                Design No *
              </label>
              <input
                type="text"
                id="designNo"
                name="designNo"
                value={formData.designNo}
                onChange={handleInputChange}
                className={`form-input ${errors.designNo ? 'error' : ''}`}
                placeholder="Enter design number"
                required
              />
              {errors.designNo && <span className="error-message">{errors.designNo}</span>}
            </div>

            <div className="form-group">
              <label htmlFor="designStitch" className="form-label">
                Design Stitch *
              </label>
              <input
                type="number"
                id="designStitch"
                name="designStitch"
                value={formData.designStitch}
                onChange={handleInputChange}
                className={`form-input ${errors.designStitch ? 'error' : ''}`}
                placeholder="Enter stitch count"
                min="1"
                required
              />
              {errors.designStitch && <span className="error-message">{errors.designStitch}</span>}
            </div>
          </div>

          <div className="form-row">
            <div className="form-group">
              <label htmlFor="colorType" className="form-label">
                CR/BL/RD *
              </label>
              <select
                id="colorType"
                name="colorType"
                value={formData.colorType}
                onChange={handleInputChange}
                className={`form-select ${errors.colorType ? 'error' : ''}`}
                required
              >
                <option value="">Select Color Type</option>
                <option value="CR">CR</option>
                <option value="BL">BL</option>
                <option value="RD">RD</option>
              </select>
              {errors.colorType && <span className="error-message">{errors.colorType}</span>}
            </div>
          </div>

          <div className="form-actions">
            <button type="submit" className="btn btn-primary">
              Submit Entry
            </button>
            <button type="button" onClick={handleReset} className="btn btn-secondary">
              Reset Form
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default ProductionEntryForm;