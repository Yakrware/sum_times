(function($) {

    var slider_markup = [
          '<div class="multirange-slider-bar">',
          '</div>'
        ].join(''),
        range_markup = [
          '<div class="multirange-slider-range">',
            '<div class="multirange-slider-left-handle"></div>',
            '<div class="multirange-slider-right-handle"></div>',
          '</div>'
        ].join(''),
        default_options = {
          min: 0,
          max: 100,
          intervals: [[0,100]],
          step: 1
        };
    
    function between(val, min, max){
      return Math.max(min, Math.min(max, val));
    }
    
    var MultirangeSlider = function(element, options){
     this.element = $(element);
     
     $.extend(this, options, {
        min: this.element.data('slider-min'),
        max: this.element.data('slider-max'),
        intervals: this.element.data('slider-intervals'),
        step: this.element.data('slider-step')
      });
            
      this.element.append(slider_markup);
      
      for(var i = 0; i < this.intervals.length; i ++){
        this.element.append(this._setIntervalCss($(range_markup), this.intervals[i][0], this.intervals[i][1]));
      }
      
      this.element.addClass('multirange-slider');
    }
    
    MultirangeSlider.prototype = {
      constructor: MultirangeSlider,
      
      _setIntervalCss: function(interval, start, end){
        var $interval = $(interval),
            _start = between(start, this.min, this.max),
            _end = between(end, this.min, this.max),
            left = between(100*(_start - this.min)/(this.max - this.min), 0, 100) + '%',
            right = between(100 - 100*(_end - this.min)/(this.max - this.min), 0, 100) + '%';
        
        $interval.find('.multirange-slider-left-handle').attr('title', start);
        $interval.find('.multirange-slider-right-handle').attr('title', end);
        
        return $interval.css({left: left, right: right});
      }
    }
    
    $.fn.multirange_slider = function(option) {
    	var _options = $.extend({}, default_options), 
    	    args = Array.apply(null, arguments),
    	    ret;
      
      args.shift();
      
      if(typeof option == 'object'){
        $.extend(_options, option);
      }
      
      this.each(function(){
        var $this = $(this),
            data = $this.data('multirange-slider');
            
        if(!data){
          // build slider
          $this.data('multirange-slider', (data = new MultirangeSlider($this, _options)) );
        }
        if (typeof option == 'string' && typeof data[option] == 'function') {
          ret = data[option].apply(data, args);
          if (ret !== undefined) return false;
        }
      });
      
      return ret !== undefined ? ret : this;
    }

}(jQuery));
