// Slideshow functionality - Hand-drawn style architecture
let currentSlide = 1;
let totalSlides = 5;
let isPlaying = true;
let slideInterval;

// Make functions global so they can be called from HTML onclick
window.nextSlide = function() {
    currentSlide++;
    if (currentSlide > totalSlides) {
        currentSlide = 1;
    }
    showSlide(currentSlide);
}

window.previousSlide = function() {
    currentSlide--;
    if (currentSlide < 1) {
        currentSlide = totalSlides;
    }
    showSlide(currentSlide);
}

window.togglePlay = function() {
    const playBtn = document.getElementById('playBtn');
    
    if (isPlaying) {
        // Pause the slideshow
        if (slideInterval) {
            clearInterval(slideInterval);
            slideInterval = null;
        }
        playBtn.textContent = '▶';
        isPlaying = false;
    } else {
        // Resume/start the slideshow
        startSlideshow();
        playBtn.textContent = '⏸';
        isPlaying = true;
    }
}

window.stopSlideshow = function() {
    if (slideInterval) {
        clearInterval(slideInterval);
        slideInterval = null;
    }
    
    // Reset to first slide
    currentSlide = 1;
    showSlide(currentSlide);
    
    const playBtn = document.getElementById('playBtn');
    if (playBtn) {
        playBtn.textContent = '▶';
    }
    isPlaying = false;
}

function showSlide(n) {
    const slides = document.querySelectorAll('.slide');
    const counter = document.getElementById('slideCounter');
    
    // Ensure currentSlide is within bounds
    if (n > totalSlides) currentSlide = 1;
    if (n < 1) currentSlide = totalSlides;
    
    // Remove active class from all slides
    slides.forEach(slide => slide.classList.remove('active'));
    
    // Add active class to current slide
    if (slides[currentSlide - 1]) {
        slides[currentSlide - 1].classList.add('active');
    }
    
    // Update counter
    if (counter) {
        counter.textContent = `Step ${currentSlide} of ${totalSlides}`;
    }
}

function startSlideshow() {
    slideInterval = setInterval(() => {
        window.nextSlide();
    }, 4000); // 4 seconds per slide for CPU pipeline
}

document.addEventListener('DOMContentLoaded', function() {
    // Initialize slideshow
    showSlide(currentSlide);
    startSlideshow();
    
    // Add smooth scrolling for any anchor links
    const links = document.querySelectorAll('a[href^="#"]');
    
    links.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href');
            const targetElement = document.querySelector(targetId);
            
            if (targetElement) {
                targetElement.scrollIntoView({
                    behavior: 'smooth'
                });
            }
        });
    });
    
    // Add copy functionality to code blocks
    const codeBlocks = document.querySelectorAll('pre code');
    
    codeBlocks.forEach(block => {
        const pre = block.parentElement;
        
        // Add copy button to each code block
        const copyButton = document.createElement('button');
        copyButton.textContent = 'Copy';
        copyButton.style.cssText = `
            position: absolute;
            top: 8px;
            right: 8px;
            background: #f6f8fa;
            border: 1px solid #e1e4e8;
            border-radius: 3px;
            padding: 4px 8px;
            font-size: 12px;
            cursor: pointer;
            opacity: 0;
            transition: opacity 0.2s;
        `;
        
        // Make pre relative for absolute positioning
        pre.style.position = 'relative';
        
        // Show copy button on hover
        pre.addEventListener('mouseenter', () => {
            copyButton.style.opacity = '1';
        });
        
        pre.addEventListener('mouseleave', () => {
            copyButton.style.opacity = '0';
        });
        
        // Add click to copy functionality
        copyButton.addEventListener('click', function(e) {
            e.stopPropagation();
            const text = block.textContent;
            
            if (navigator.clipboard) {
                navigator.clipboard.writeText(text).then(() => {
                    // Visual feedback
                    copyButton.textContent = 'Copied!';
                    copyButton.style.background = '#e6ffed';
                    
                    setTimeout(() => {
                        copyButton.textContent = 'Copy';
                        copyButton.style.background = '#f6f8fa';
                    }, 1000);
                });
            }
        });
        
        pre.appendChild(copyButton);
        
        // Also add click to copy on the entire pre block
        pre.addEventListener('click', function() {
            const text = block.textContent;
            
            if (navigator.clipboard) {
                navigator.clipboard.writeText(text).then(() => {
                    // Visual feedback
                    const originalBg = pre.style.backgroundColor;
                    pre.style.backgroundColor = '#e6ffed';
                    
                    setTimeout(() => {
                        pre.style.backgroundColor = originalBg;
                    }, 200);
                });
            }
        });
        
        // Add cursor pointer to indicate clickability
        pre.style.cursor = 'pointer';
        pre.title = 'Click to copy code';
    });
    
    // Add loading states for external links
    const externalLinks = document.querySelectorAll('a[href^="http"]');
    
    externalLinks.forEach(link => {
        link.addEventListener('click', function() {
            // Add subtle loading state
            this.style.opacity = '0.7';
            
            setTimeout(() => {
                this.style.opacity = '1';
            }, 150);
        });
    });
});

// Simple reading progress indicator
window.addEventListener('scroll', function() {
    const winScroll = document.body.scrollTop || document.documentElement.scrollTop;
    const height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
    const scrolled = (winScroll / height) * 100;
    
    // Create or update progress bar
    let progressBar = document.getElementById('reading-progress');
    if (!progressBar) {
        progressBar = document.createElement('div');
        progressBar.id = 'reading-progress';
        progressBar.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            width: 0%;
            height: 2px;
            background: #0366d6;
            z-index: 1000;
            transition: width 0.1s ease;
        `;
        document.body.appendChild(progressBar);
    }
    
    progressBar.style.width = scrolled + '%';
});