import React, { useState } from 'react';
import { ArrowLeft, Send, MapPin, Phone, User, CreditCard, FileText, Calendar, Clock, Copy, Check, ExternalLink, X, CheckCircle2, MessageSquare } from 'lucide-react';
import { CartItem, PaymentMethod } from '../types';
import { usePaymentMethods } from '../hooks/usePaymentMethods';

interface CheckoutProps {
  cartItems: CartItem[];
  totalPrice: number;
  onBack: () => void;
}

const Checkout: React.FC<CheckoutProps> = ({ cartItems, totalPrice, onBack }) => {
  const { paymentMethods } = usePaymentMethods();
  const [customerName, setCustomerName] = useState('');
  const [contactNumber, setContactNumber] = useState('');
  const [address, setAddress] = useState('');
  const [deliveryDate, setDeliveryDate] = useState('');
  const [deliveryTime, setDeliveryTime] = useState('');
  const [paymentMethod, setPaymentMethod] = useState<PaymentMethod>('gcash');
  const [notes, setNotes] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [copied, setCopied] = useState(false);
  const [generatedOrder, setGeneratedOrder] = useState('');

  // Get minimum date (tomorrow)
  const getMinDate = () => {
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    return tomorrow.toISOString().split('T')[0];
  };

  // Time slot options
  const timeSlots = [
    { value: 'morning', label: '🌅 Morning (8:00 AM - 12:00 PM)' },
    { value: 'afternoon', label: '☀️ Afternoon (12:00 PM - 5:00 PM)' },
    { value: 'evening', label: '🌙 Evening (5:00 PM - 8:00 PM)' },
  ];

  React.useEffect(() => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }, []);

  // Set default payment method when payment methods are loaded
  React.useEffect(() => {
    if (paymentMethods.length > 0 && !paymentMethod) {
      setPaymentMethod(paymentMethods[0].id as PaymentMethod);
    }
  }, [paymentMethods, paymentMethod]);

  const selectedPaymentMethod = paymentMethods.find(method => method.id === paymentMethod);

  // Generate order text for cart items
  const getOrderText = () => {
    return cartItems.map(item => {
      let itemText = `• ${item.name}`;
      if (item.selectedVariation) {
        itemText += ` (${item.selectedVariation.name})`;
      }
      if (item.selectedAddOns && item.selectedAddOns.length > 0) {
        itemText += ` + ${item.selectedAddOns.map(addOn => 
          addOn.quantity && addOn.quantity > 1 
            ? `${addOn.name} x${addOn.quantity}`
            : addOn.name
        ).join(', ')}`;
      }
      itemText += ` x${item.quantity} = ₱${item.totalPrice * item.quantity}`;
      return itemText;
    }).join('\n');
  };

  // Format date for display
  const formatDeliveryDate = (dateString: string) => {
    if (!dateString) return '';
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });
  };

  // Get time slot label
  const getTimeSlotLabel = (value: string) => {
    const slot = timeSlots.find(s => s.value === value);
    return slot ? slot.label : value;
  };

  const generateOrderMessage = () => {
    const deliveryInfo = deliveryDate || deliveryTime 
      ? `\n📅 𝗣𝗿𝗲𝗳𝗲𝗿𝗿𝗲𝗱 𝗗𝗲𝗹𝗶𝘃𝗲𝗿𝘆:\n${deliveryDate ? `Date: ${formatDeliveryDate(deliveryDate)}` : ''}${deliveryDate && deliveryTime ? '\n' : ''}${deliveryTime ? `Time: ${getTimeSlotLabel(deliveryTime)}` : ''}\n`
      : '';

    return `
🥩 THE PERFECT RIBEYE PH - ORDER FORM 🥩

━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 𝗢𝗥𝗗𝗘𝗥:
${getOrderText()}

💰 TOTAL: ₱${totalPrice.toLocaleString()}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💳 𝗣𝗮𝘆𝗺𝗲𝗻𝘁 𝗠𝗲𝘁𝗵𝗼𝗱: ${selectedPaymentMethod?.name || paymentMethod}

👤 𝗖𝗼𝗻𝘁𝗮𝗰𝘁 𝗣𝗲𝗿𝘀𝗼𝗻 & 𝗡𝘂𝗺𝗯𝗲𝗿: 
${customerName}
${contactNumber}

📍 𝗔𝗱𝗱𝗿𝗲𝘀𝘀: 
${address}
${deliveryInfo}
${notes ? `📝 𝗡𝗼𝘁𝗲𝘀: ${notes}` : ''}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📸 Please attach your payment screenshot.

Thank you for choosing The Perfect Ribeye PH! 🥩🔥
    `.trim();
  };

  const copyToClipboard = async (text: string): Promise<boolean> => {
    try {
      if (navigator.clipboard && window.isSecureContext) {
        await navigator.clipboard.writeText(text);
        return true;
      }
    } catch (err) {
      console.warn('Clipboard API error, trying fallback', err);
    }

    try {
      const textArea = document.createElement('textarea');
      textArea.value = text;
      textArea.style.position = 'fixed';
      textArea.style.left = '-999999px';
      textArea.style.top = '-999999px';
      document.body.appendChild(textArea);
      textArea.focus();
      textArea.select();
      const success = document.execCommand('copy');
      textArea.remove();
      return success;
    } catch (err) {
      console.error('Fallback clipboard copy failed', err);
      return false;
    }
  };

  const handleSendOrder = async () => {
    const orderMessage = generateOrderMessage();
    setGeneratedOrder(orderMessage);
    await copyToClipboard(orderMessage);
    setCopied(true);
    setShowModal(true);

    const messengerUrl = 'https://m.me/360416760484907';
    window.open(messengerUrl, '_blank');
  };

  const handleManualCopy = async () => {
    if (generatedOrder) {
      await copyToClipboard(generatedOrder);
      setCopied(true);
      setTimeout(() => setCopied(false), 3000);
    }
  };

  const isFormValid = customerName && contactNumber && address && paymentMethod;

  return (
    <div className="min-h-screen py-8 px-4">
      <div className="max-w-5xl mx-auto">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <button
            onClick={onBack}
            className="flex items-center space-x-2 text-gray-400 hover:text-white transition-all duration-300 group bg-gray-800/50 px-4 py-2 rounded-full border border-gray-700/50 hover:border-red-600/50"
          >
            <ArrowLeft className="h-4 w-4 group-hover:-translate-x-1 transition-transform duration-200" />
            <span className="text-sm font-medium">Back to Cart</span>
          </button>
          
          {/* Step Indicator */}
          <div className="hidden md:flex items-center space-x-2 text-sm">
            <span className="text-gray-500">Cart</span>
            <span className="text-gray-600">→</span>
            <span className="text-red-500 font-semibold">Checkout</span>
          </div>
        </div>

        {/* Order Form Header */}
        <div className="text-center mb-12">
          <div className="inline-flex items-center justify-center w-20 h-20 bg-gradient-to-br from-red-600/20 to-red-900/20 rounded-full mb-6 border border-red-600/30">
            <span className="text-4xl">🥩</span>
          </div>
          <h1 className="text-4xl font-bold text-white mb-3 tracking-tight">Complete Your Order</h1>
          <p className="text-gray-400 max-w-lg mx-auto leading-relaxed">
            Fill out the form below and we'll prepare your premium steaks with care
          </p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-5 gap-8">
          {/* Order Summary Card - Left Side */}
          <div className="lg:col-span-2">
            <div className="sticky top-24 space-y-6">
              {/* Order Items Card */}
              <div className="bg-gradient-to-br from-gray-800/80 to-gray-900/80 backdrop-blur-sm rounded-2xl shadow-2xl overflow-hidden border border-gray-700/50">
                <div className="bg-gradient-to-r from-red-600/10 to-transparent p-5 border-b border-gray-700/50">
                  <div className="flex items-center space-x-3">
                    <div className="w-10 h-10 bg-red-600/20 rounded-xl flex items-center justify-center">
                      <FileText className="w-5 h-5 text-red-500" />
                    </div>
                    <div>
                      <h2 className="text-lg font-bold text-white">Order Summary</h2>
                      <p className="text-xs text-gray-400">{cartItems.length} item(s)</p>
                    </div>
                  </div>
                </div>
                
                <div className="p-5 space-y-4 max-h-64 overflow-y-auto scrollbar-hide">
                  {cartItems.map((item) => (
                    <div key={item.id} className="flex items-start justify-between group">
                      <div className="flex-1 min-w-0">
                        <h4 className="font-semibold text-white text-sm truncate">{item.name}</h4>
                        {item.selectedVariation && (
                          <p className="text-xs text-amber-400 flex items-center space-x-1">
                            <span>⚡</span>
                            <span>{item.selectedVariation.name}</span>
                          </p>
                        )}
                        {item.selectedAddOns && item.selectedAddOns.length > 0 && (
                          <p className="text-xs text-gray-500 truncate">
                            + {item.selectedAddOns.map(addOn => addOn.name).join(', ')}
                          </p>
                        )}
                        <p className="text-xs text-gray-500 mt-1">
                          ₱{item.totalPrice.toLocaleString()} × {item.quantity}
                        </p>
                      </div>
                      <span className="font-bold text-white text-sm ml-4">
                        ₱{(item.totalPrice * item.quantity).toLocaleString()}
                      </span>
                    </div>
                  ))}
                </div>
                
                {/* Totals */}
                <div className="bg-gray-900/50 p-5 space-y-3">
                  <div className="flex items-center justify-between text-sm text-gray-400">
                    <span>Subtotal</span>
                    <span>₱{totalPrice.toLocaleString()}</span>
                  </div>
                  <div className="flex items-center justify-between text-sm text-gray-400">
                    <span>Delivery</span>
                    <span className="text-green-400 text-xs">Calculated after</span>
                  </div>
                  <div className="h-px bg-gradient-to-r from-transparent via-gray-700 to-transparent"></div>
                  <div className="flex items-center justify-between">
                    <span className="text-lg font-bold text-white">Total</span>
                    <span className="text-2xl font-bold text-red-400">₱{totalPrice.toLocaleString()}</span>
                  </div>
                </div>
              </div>

              {/* Security Badges */}
              <div className="flex items-center justify-center space-x-4 text-xs text-gray-500">
                <div className="flex items-center space-x-1">
                  <span>🔒</span>
                  <span>Secure</span>
                </div>
                <div className="w-1 h-1 bg-gray-600 rounded-full"></div>
                <div className="flex items-center space-x-1">
                  <span>🚚</span>
                  <span>Fast Delivery</span>
                </div>
                <div className="w-1 h-1 bg-gray-600 rounded-full"></div>
                <div className="flex items-center space-x-1">
                  <span>⭐</span>
                  <span>Premium</span>
                </div>
              </div>
            </div>
          </div>

          {/* Order Form - Right Side */}
          <div className="lg:col-span-3">
            <div className="bg-gradient-to-br from-gray-800/80 to-gray-900/80 backdrop-blur-sm rounded-2xl shadow-2xl border border-gray-700/50 overflow-hidden">
              <div className="bg-gradient-to-r from-red-600/10 to-transparent p-5 border-b border-gray-700/50">
                <div className="flex items-center space-x-3">
                  <div className="w-10 h-10 bg-red-600/20 rounded-xl flex items-center justify-center">
                    <Send className="w-5 h-5 text-red-500" />
                  </div>
                  <div>
                    <h2 className="text-lg font-bold text-white">Delivery Details</h2>
                    <p className="text-xs text-gray-400">Please fill in your information</p>
                  </div>
                </div>
              </div>
              
              <form className="p-6 space-y-6">
                {/* Payment Method */}
                <div>
                  <label className="flex items-center space-x-2 text-sm font-semibold text-white mb-4">
                    <CreditCard className="w-4 h-4 text-red-400" />
                    <span>Payment Method</span>
                    <span className="text-red-400">*</span>
                  </label>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    {paymentMethods.map((method) => (
                      <button
                        key={method.id}
                        type="button"
                        onClick={() => setPaymentMethod(method.id as PaymentMethod)}
                        className={`relative p-4 rounded-xl border-2 transition-all duration-300 flex items-center space-x-3 group overflow-hidden ${
                          paymentMethod === method.id
                            ? 'border-red-500 bg-gradient-to-br from-red-900/40 to-red-900/20 shadow-lg shadow-red-900/20'
                            : 'border-gray-700 bg-gray-800/30 hover:border-gray-600 hover:bg-gray-800/50'
                        }`}
                      >
                        {/* Selection indicator glow */}
                        {paymentMethod === method.id && (
                          <div className="absolute inset-0 bg-gradient-to-r from-red-600/5 to-transparent"></div>
                        )}
                        
                        <div className={`w-10 h-10 rounded-lg flex items-center justify-center flex-shrink-0 transition-colors ${
                          paymentMethod === method.id ? 'bg-red-600/30' : 'bg-gray-700/50'
                        }`}>
                          <span className="text-xl">
                            {method.id.includes('cod') || method.id.includes('cash') ? '💵' : 
                             method.id.includes('bank') ? '🏦' : '💳'}
                          </span>
                        </div>
                        <div className="text-left flex-1 min-w-0 relative z-10">
                          <span className={`font-semibold block text-sm ${paymentMethod === method.id ? 'text-white' : 'text-gray-300'}`}>
                            {method.name}
                          </span>
                          <span className="text-xs text-gray-500 truncate block">{method.account_number}</span>
                        </div>
                        {paymentMethod === method.id && (
                          <div className="w-6 h-6 bg-red-500 rounded-full flex items-center justify-center flex-shrink-0">
                            <svg className="w-3 h-3 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" />
                            </svg>
                          </div>
                        )}
                      </button>
                    ))}
                  </div>
                  
                  {/* Payment Account Details or COD Message */}
                  {selectedPaymentMethod && (
                    <div className="mt-4 p-4 bg-gradient-to-br from-gray-900/80 to-gray-900/50 rounded-xl border border-gray-700/50">
                      {selectedPaymentMethod.id.includes('cod') || (selectedPaymentMethod.id.includes('cash') && !selectedPaymentMethod.id.includes('gcash')) || selectedPaymentMethod.id === 'cash' ? (
                        /* Cash on Delivery Message */
                        <div className="flex items-center space-x-3">
                          <div className="w-12 h-12 bg-green-600/20 rounded-xl flex items-center justify-center flex-shrink-0">
                            <span className="text-2xl">💵</span>
                          </div>
                          <div>
                            <p className="font-semibold text-white">Pay upon delivery</p>
                            <p className="text-sm text-gray-400">Please prepare the exact amount: <span className="text-green-400 font-bold">₱{totalPrice.toLocaleString()}</span></p>
                          </div>
                        </div>
                      ) : (
                        /* Digital Payment / Bank Transfer Details */
                        <div className="flex items-center justify-between">
                          <div>
                            <p className="text-xs text-gray-500 uppercase tracking-wider mb-1">Send payment to</p>
                            <p className="font-mono text-xl text-white font-bold tracking-wider">{selectedPaymentMethod.account_number}</p>
                            <p className="text-sm text-gray-400 mt-1">{selectedPaymentMethod.account_name}</p>
                          </div>
                          {selectedPaymentMethod.qr_code_url && !selectedPaymentMethod.qr_code_url.includes('placeholder') && (
                            <div className="p-1 bg-white rounded-lg shadow-lg">
                              <img 
                                src={selectedPaymentMethod.qr_code_url} 
                                alt="QR Code"
                                className="w-16 h-16 rounded"
                              />
                            </div>
                          )}
                        </div>
                      )}
                    </div>
                  )}
                </div>

                {/* Divider */}
                <div className="h-px bg-gradient-to-r from-transparent via-gray-700 to-transparent"></div>

                {/* Contact Information */}
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className="flex items-center space-x-2 text-sm font-semibold text-white mb-2">
                      <User className="w-4 h-4 text-red-400" />
                      <span>Full Name</span>
                      <span className="text-red-400">*</span>
                    </label>
                    <input
                      type="text"
                      value={customerName}
                      onChange={(e) => setCustomerName(e.target.value)}
                      className="w-full px-4 py-3.5 bg-gray-800/50 border border-gray-700 rounded-xl focus:ring-2 focus:ring-red-500 focus:border-red-500 transition-all duration-200 text-white placeholder-gray-500 text-sm"
                      placeholder="Juan Dela Cruz"
                      required
                    />
                  </div>
                  <div>
                    <label className="flex items-center space-x-2 text-sm font-semibold text-white mb-2">
                      <Phone className="w-4 h-4 text-red-400" />
                      <span>Contact Number</span>
                      <span className="text-red-400">*</span>
                    </label>
                    <input
                      type="tel"
                      value={contactNumber}
                      onChange={(e) => {
                        // Only allow numbers and limit to 11 digits
                        const value = e.target.value.replace(/\D/g, '').slice(0, 11);
                        setContactNumber(value);
                      }}
                      className="w-full px-4 py-3.5 bg-gray-800/50 border border-gray-700 rounded-xl focus:ring-2 focus:ring-red-500 focus:border-red-500 transition-all duration-200 text-white placeholder-gray-500 text-sm"
                      placeholder="09XX XXX XXXX"
                      maxLength={11}
                      required
                    />
                  </div>
                </div>

                {/* Address */}
                <div>
                  <label className="flex items-center space-x-2 text-sm font-semibold text-white mb-2">
                    <MapPin className="w-4 h-4 text-red-400" />
                    <span>Delivery Address</span>
                    <span className="text-red-400">*</span>
                  </label>
                  <textarea
                    value={address}
                    onChange={(e) => setAddress(e.target.value)}
                    className="w-full px-4 py-3.5 bg-gray-800/50 border border-gray-700 rounded-xl focus:ring-2 focus:ring-red-500 focus:border-red-500 transition-all duration-200 text-white placeholder-gray-500 resize-none text-sm"
                    placeholder="House #, Street, Barangay, City, Province"
                    rows={2}
                    required
                  />
                </div>

                {/* Delivery Scheduling */}
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className="flex items-center space-x-2 text-sm font-semibold text-white mb-2">
                      <Calendar className="w-4 h-4 text-red-400" />
                      <span>Preferred Delivery Date</span>
                      <span className="text-gray-500 text-xs font-normal">(Optional)</span>
                    </label>
                    <input
                      type="date"
                      value={deliveryDate}
                      onChange={(e) => setDeliveryDate(e.target.value)}
                      min={getMinDate()}
                      className="w-full px-4 py-3.5 bg-gray-800/50 border border-gray-700 rounded-xl focus:ring-2 focus:ring-red-500 focus:border-red-500 transition-all duration-200 text-white placeholder-gray-500 text-sm [color-scheme:dark]"
                    />
                  </div>
                  <div>
                    <label className="flex items-center space-x-2 text-sm font-semibold text-white mb-2">
                      <Clock className="w-4 h-4 text-red-400" />
                      <span>Preferred Time Slot</span>
                      <span className="text-gray-500 text-xs font-normal">(Optional)</span>
                    </label>
                    <select
                      value={deliveryTime}
                      onChange={(e) => setDeliveryTime(e.target.value)}
                      className="w-full px-4 py-3.5 bg-gray-800/50 border border-gray-700 rounded-xl focus:ring-2 focus:ring-red-500 focus:border-red-500 transition-all duration-200 text-white text-sm appearance-none cursor-pointer"
                    >
                      <option value="" className="bg-gray-800">Select a time slot</option>
                      {timeSlots.map((slot) => (
                        <option key={slot.value} value={slot.value} className="bg-gray-800">
                          {slot.label}
                        </option>
                      ))}
                    </select>
                  </div>
                </div>


                {/* Notes */}
                <div>
                  <label className="flex items-center space-x-2 text-sm font-semibold text-white mb-2">
                    <FileText className="w-4 h-4 text-red-400" />
                    <span>Special Instructions</span>
                    <span className="text-gray-500 text-xs font-normal">(Optional)</span>
                  </label>
                  <textarea
                    value={notes}
                    onChange={(e) => setNotes(e.target.value)}
                    className="w-full px-4 py-3.5 bg-gray-800/50 border border-gray-700 rounded-xl focus:ring-2 focus:ring-red-500 focus:border-red-500 transition-all duration-200 text-white placeholder-gray-500 resize-none text-sm"
                    placeholder="Cooking preferences, delivery instructions, etc."
                    rows={2}
                  />
                </div>

                {/* Payment Reminder */}
                <div className="bg-gradient-to-r from-amber-900/30 to-amber-900/10 border border-amber-600/30 rounded-xl p-4">
                  <div className="flex items-start space-x-3">
                    <div className="w-10 h-10 bg-amber-600/20 rounded-lg flex items-center justify-center flex-shrink-0">
                      <span className="text-xl">📸</span>
                    </div>
                    <div>
                      <h4 className="font-semibold text-amber-400 text-sm">Payment Screenshot Required</h4>
                      <p className="text-xs text-gray-400 mt-1 leading-relaxed">
                        After sending your order, please attach your payment receipt screenshot in the Messenger chat.
                      </p>
                    </div>
                  </div>
                </div>

                {/* Submit Button */}
                <button
                  type="button"
                  onClick={handleSendOrder}
                  disabled={!isFormValid}
                  className={`w-full relative overflow-hidden py-4 rounded-xl font-bold text-lg transition-all duration-500 transform flex items-center justify-center space-x-3 group ${
                    isFormValid
                      ? 'bg-gradient-to-r from-red-600 via-red-500 to-red-600 text-white hover:shadow-2xl hover:shadow-red-600/30 hover:scale-[1.02] border border-red-400/20'
                      : 'bg-gray-800 text-gray-500 cursor-not-allowed border border-gray-700'
                  }`}
                >
                  {isFormValid && (
                    <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/10 to-transparent -translate-x-full group-hover:translate-x-full transition-transform duration-1000"></div>
                  )}
                  <Send className="w-5 h-5 relative z-10" />
                  <span className="relative z-10">Send Order via Messenger</span>
                </button>

                <p className="text-xs text-gray-500 text-center">
                  Awtomatikong kokopyahin ang iyong order details sa clipboard at bubuksan ang Messenger 🥩
                </p>
              </form>
            </div>
          </div>
        </div>
      </div>

      {/* Messenger Order Instructions Modal */}
      {showModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/85 backdrop-blur-md animate-in fade-in duration-200">
          <div className="bg-gradient-to-b from-gray-900 via-gray-900 to-gray-950 border border-red-600/40 rounded-2xl p-6 sm:p-8 max-w-lg w-full shadow-2xl relative max-h-[92vh] flex flex-col text-left">
            {/* Close Button */}
            <button
              onClick={() => setShowModal(false)}
              className="absolute top-4 right-4 text-gray-400 hover:text-white p-2 rounded-full hover:bg-gray-800/80 transition-colors"
              aria-label="Close modal"
            >
              <X className="w-5 h-5" />
            </button>

            {/* Modal Header */}
            <div className="flex items-center space-x-3 mb-4">
              <div className="w-12 h-12 rounded-xl bg-emerald-500/20 border border-emerald-500/40 flex items-center justify-center flex-shrink-0">
                <CheckCircle2 className="w-7 h-7 text-emerald-400" />
              </div>
              <div>
                <h3 className="text-xl font-bold text-white">Nai-copy na ang iyong Order! 📋</h3>
                <p className="text-xs sm:text-sm text-emerald-400 font-medium">Ready to paste into Facebook Messenger</p>
              </div>
            </div>

            {/* Explanation / Guidance */}
            <div className="bg-red-950/40 border border-red-800/30 rounded-xl p-3.5 mb-4 text-xs sm:text-sm text-gray-300 leading-relaxed">
              <span className="font-semibold text-red-400">💡 Paalala:</span> Dahil sa security policy ng Facebook, hindi awtomatikong lumalabas ang text sa chat box. <strong className="text-white">Awtomatikong kinopya na namin ang order details sa iyong clipboard</strong>!
            </div>

            {/* 3 Simple Steps */}
            <div className="space-y-2 mb-4 text-xs sm:text-sm">
              <div className="flex items-start space-x-2.5 bg-gray-800/50 p-2.5 rounded-lg border border-gray-700/50">
                <span className="w-5 h-5 rounded-full bg-red-600/30 text-red-400 text-xs flex items-center justify-center font-bold flex-shrink-0 mt-0.5">1</span>
                <span className="text-gray-300">Nai-copy na sa iyong clipboard ang kumpletong order summary.</span>
              </div>
              <div className="flex items-start space-x-2.5 bg-gray-800/50 p-2.5 rounded-lg border border-gray-700/50">
                <span className="w-5 h-5 rounded-full bg-red-600/30 text-red-400 text-xs flex items-center justify-center font-bold flex-shrink-0 mt-0.5">2</span>
                <span className="text-gray-300">Pumunta sa Messenger chat at mag-<strong>Paste</strong> (<kbd className="px-1.5 py-0.5 bg-gray-700 rounded text-xs text-white">Ctrl + V</kbd> o Long Press ➔ Paste).</span>
              </div>
              <div className="flex items-start space-x-2.5 bg-gray-800/50 p-2.5 rounded-lg border border-gray-700/50">
                <span className="w-5 h-5 rounded-full bg-red-600/30 text-red-400 text-xs flex items-center justify-center font-bold flex-shrink-0 mt-0.5">3</span>
                <span className="text-gray-300">Pindutin ang <strong>Send</strong> at i-attach ang payment screenshot receipt.</span>
              </div>
            </div>

            {/* Order Text Preview Box */}
            <div className="relative mb-5 flex-1 min-h-0 flex flex-col">
              <div className="flex items-center justify-between mb-1.5 text-xs text-gray-400">
                <span>Preview ng iyong Order:</span>
                <button
                  type="button"
                  onClick={handleManualCopy}
                  className="flex items-center space-x-1 text-xs text-red-400 hover:text-red-300 font-semibold px-2 py-1 rounded bg-red-950/60 border border-red-800/40 hover:border-red-600/60 transition-colors"
                >
                  {copied ? (
                    <>
                      <Check className="w-3.5 h-3.5 text-emerald-400" />
                      <span className="text-emerald-400">✓ Nakopya!</span>
                    </>
                  ) : (
                    <>
                      <Copy className="w-3.5 h-3.5" />
                      <span>Kopyahin Ulit</span>
                    </>
                  )}
                </button>
              </div>
              <pre className="w-full max-h-36 overflow-y-auto p-3 bg-gray-950 border border-gray-800 rounded-xl text-xs text-gray-300 font-mono whitespace-pre-wrap selection:bg-red-600/40">
                {generatedOrder}
              </pre>
            </div>

            {/* Actions */}
            <div className="space-y-2 pt-2 border-t border-gray-800">
              <a
                href="https://m.me/360416760484907"
                target="_blank"
                rel="noopener noreferrer"
                className="w-full py-3.5 px-4 bg-gradient-to-r from-red-600 to-red-700 hover:from-red-500 hover:to-red-600 text-white font-bold rounded-xl flex items-center justify-center space-x-2 shadow-lg shadow-red-600/30 transition-all hover:scale-[1.01]"
              >
                <MessageSquare className="w-5 h-5" />
                <span>Buksan ang Facebook Messenger</span>
                <ExternalLink className="w-4 h-4 ml-1" />
              </a>
              <button
                type="button"
                onClick={() => setShowModal(false)}
                className="w-full py-2.5 px-4 bg-gray-800/70 hover:bg-gray-800 text-gray-300 hover:text-white rounded-xl text-sm font-medium transition-colors"
              >
                Isara (Tapos na akong mag-order)
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default Checkout;
