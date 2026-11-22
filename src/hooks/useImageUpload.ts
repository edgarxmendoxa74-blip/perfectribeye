import { useState } from 'react';
import { supabase } from '../lib/supabase';

const CLOUDINARY_CLOUD_NAME = import.meta.env.VITE_CLOUDINARY_CLOUD_NAME || 'yuph013q';
const CLOUDINARY_UPLOAD_PRESET = import.meta.env.VITE_CLOUDINARY_UPLOAD_PRESET || 'ribeye';

export const useImageUpload = () => {
  const [uploading, setUploading] = useState(false);
  const [uploadProgress, setUploadProgress] = useState(0);

  const uploadToCloudinary = (file: File, folder?: string): Promise<string> => {
    return new Promise((resolve, reject) => {
      const xhr = new XMLHttpRequest();
      const url = `https://api.cloudinary.com/v1_1/${CLOUDINARY_CLOUD_NAME}/image/upload`;

      xhr.open('POST', url);

      xhr.upload.onprogress = (event) => {
        if (event.lengthComputable) {
          const percent = Math.round((event.loaded / event.total) * 100);
          setUploadProgress(percent);
        }
      };

      xhr.onload = () => {
        if (xhr.status >= 200 && xhr.status < 300) {
          try {
            const response = JSON.parse(xhr.responseText);
            // Automatically insert f_auto,q_auto for best performance and format conversion (WebP/AVIF)
            let optimizedUrl = response.secure_url || response.url;
            if (optimizedUrl && optimizedUrl.includes('/upload/')) {
              optimizedUrl = optimizedUrl.replace('/upload/', '/upload/f_auto,q_auto/');
            }
            resolve(optimizedUrl);
          } catch {
            reject(new Error('Failed to parse Cloudinary response'));
          }
        } else {
          try {
            const errorResponse = JSON.parse(xhr.responseText);
            reject(new Error(errorResponse.error?.message || 'Cloudinary upload failed'));
          } catch {
            reject(new Error(`Upload failed with status ${xhr.status}`));
          }
        }
      };

      xhr.onerror = () => {
        reject(new Error('Network error during upload to Cloudinary. Check your internet connection.'));
      };

      const formData = new FormData();
      formData.append('file', file);
      formData.append('upload_preset', CLOUDINARY_UPLOAD_PRESET);
      if (folder) {
        formData.append('folder', folder);
      }

      xhr.send(formData);
    });
  };

  const uploadImage = async (file: File, folder?: string): Promise<string> => {
    try {
      setUploading(true);
      setUploadProgress(0);

      // Validate file type
      const allowedTypes = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
      if (!allowedTypes.includes(file.type)) {
        throw new Error('Please upload a valid image file (JPEG, PNG, WebP, or GIF)');
      }

      // Validate file size (up to 10MB on Cloudinary)
      const maxSize = 10 * 1024 * 1024;
      if (file.size > maxSize) {
        throw new Error('Image size must be less than 10MB');
      }

      // Use Cloudinary if configured (zero Supabase egress!)
      if (CLOUDINARY_CLOUD_NAME && CLOUDINARY_UPLOAD_PRESET) {
        const url = await uploadToCloudinary(file, folder || 'perfectribeye');
        setUploadProgress(100);
        return url;
      }

      // Fallback to Supabase Storage if Cloudinary credentials are not present
      const fileExt = file.name.split('.').pop();
      const fileName = `${Date.now()}-${Math.random().toString(36).substring(2)}.${fileExt}`;

      const { data, error } = await supabase.storage
        .from('menu-images')
        .upload(fileName, file, {
          cacheControl: '3600',
          upsert: false,
          contentType: file.type
        });

      if (error) {
        throw error;
      }

      const { data: { publicUrl } } = supabase.storage
        .from('menu-images')
        .getPublicUrl(data.path);

      setUploadProgress(100);
      return publicUrl;
    } catch (error) {
      console.error('Error uploading image:', error);
      throw error;
    } finally {
      setUploading(false);
      setTimeout(() => setUploadProgress(0), 1000);
    }
  };

  const deleteImage = async (imageUrl: string): Promise<void> => {
    try {
      // If the image was originally in Supabase Storage, delete it from there
      if (imageUrl.includes('supabase.co/storage')) {
        const urlParts = imageUrl.split('/');
        const fileName = urlParts[urlParts.length - 1];

        await supabase.storage
          .from('menu-images')
          .remove([fileName]);
      }
      // Note: Cloudinary unsigned presets intentionally disallow direct client-side deletions for security
    } catch (error) {
      console.error('Error deleting image:', error);
    }
  };

  return {
    uploadImage,
    deleteImage,
    uploading,
    uploadProgress
  };
};
