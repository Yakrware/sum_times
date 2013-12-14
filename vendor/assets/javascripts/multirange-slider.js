(function($) {

    var slider_markup = [
          '<div class="multirange-slider-bar">',
          '</div>'
        ].join(''),
        range_markup = [
          '<div class="multirange-slider-range">',
            '<a class="multirange-slider-handle multirange-slider-handle-left"></a>',
            '<a class="multirange-slider-handle multirange-slider-handle-right"></a>',
          '</div>'
        ].join(''),
        default_options = {
          min: 0,
          max: 100,
          intervals: [[0,100]],
          step: 1,
          displayFormat: function(val){ return val; },
          showTip: true
        },
        unique_number = 0;
        
    function between(val, min, max){
      return Math.max(min, Math.min(max, val));
    }
    
    function sortManyArray(a, b){
      return a[0] - b[0];
    }
    
    var MultirangeSlider = function(element, options){
      this.element = $(element);
      this.unique_number = ++unique_number;
     
      $.extend(this, options, {
        min: this.element.data('slider-min'),
        max: this.element.data('slider-max'),
        intervals: this.element.data('slider-intervals'),
        step: this.element.data('slider-step')
      });
           
      this.element.append(slider_markup);
      this.drag_data = {};
      this.scale_factor = 1/this.step;
      
      this._drawIntervals();
      
      if(this.showTip){ this.element.addClass('multirange-slider-showtip'); }
      
      this._mousedown = $.proxy(this._dragStart, null, this);
      this._mousemove = $.proxy(this._dragMove, null, this);
      this._mouseup = $.proxy(this._dragEnd, null, this);
      !this.disabled ? this.enable() : this.disable();
      
      this.element.addClass('multirange-slider');
    }
        
    MultirangeSlider.prototype = {
      constructor: MultirangeSlider,
      
      _drawIntervals: function(){
        this.element.find('.multirange-slider-range').remove();
        for(var i = 0; i < this.intervals.length; i ++){
          var interval = this._setIntervalCss($(range_markup), this.intervals[i][0], this.intervals[i][1]);
          interval.data('interval_index', i);
          if(this.intervals[i][2]){
            interval.addClass(this.intervals[i][2]);
          }
          this.element.append(interval);
        }
        
        if(!this.disabled){
          setTimeout($.proxy(function(){
            this.element.find('.multirange-slider-handle').tooltip('show');
          }, this), 1);
        }
      },
      
      _setIntervalCss: function(interval, start, end){
        var $interval = $(interval),
            _start = between(start, this.min, this.max),
            _end = between(end, this.min, this.max),
            left = between(100*(_start - this.min)/(this.max - this.min), 0, 100) + '%',
            right = between(100 - 100*(_end - this.min)/(this.max - this.min), 0, 100) + '%';
            
        $interval.css({left: left, right: right});
        
        $interval.find('.multirange-slider-handle-left').attr('data-original-title', this.displayFormat(start)).tooltip({trigger: this.showTip ? 'manual' : 'hover', html: true, animation: false});
        $interval.find('.multirange-slider-handle-right').attr('data-original-title', this.displayFormat(end)).tooltip({trigger: this.showTip ? 'manual' : 'hover', html: true, animation: false});
        
        
        return $interval;
      },
      
      _dragStart: function(slider, e){
        var $this = $(this);
        slider.drag_data.handle = $this;
        slider.drag_data.interval_index = $this.closest('.multirange-slider-range').data('interval_index');
        slider.drag_data.interval_side = $this.hasClass('multirange-slider-handle-left') ? 0 : 1;
        slider.drag_data.start_interval = slider.intervals[slider.drag_data.interval_index][slider.drag_data.interval_side];
        slider.drag_data.min = slider.drag_data.interval_side == 0 ? (slider.intervals[slider.drag_data.interval_index-1] ? slider.intervals[slider.drag_data.interval_index-1][1] : slider.min) : slider.intervals[slider.drag_data.interval_index][0];
        slider.drag_data.max = slider.drag_data.interval_side == 0 ? slider.intervals[slider.drag_data.interval_index][1] : (slider.intervals[slider.drag_data.interval_index+1] ? slider.intervals[slider.drag_data.interval_index+1][0] : slider.max);
        slider.drag_data.el_start = slider.element.offset().left;
        slider.drag_data.el_end = slider.drag_data.el_start + slider.element.width();
        e.preventDefault();
      },
      
      _dragMove: function(slider, e){
        if(slider.drag_data.handle){
          var percent = (e.clientX - slider.drag_data.el_start)/(slider.drag_data.el_end - slider.drag_data.el_start);
          slider.intervals[slider.drag_data.interval_index][slider.drag_data.interval_side] = between(slider._snapValue(slider.min + percent*(slider.max-slider.min)).toFixed(2), slider.drag_data.min, slider.drag_data.max);
          slider._setIntervalCss(slider.drag_data.handle.closest('.multirange-slider-range'), slider.intervals[slider.drag_data.interval_index][0], slider.intervals[slider.drag_data.interval_index][1]);
          slider.drag_data.handle.tooltip('fixTitle').tooltip('setContent');
          slider.drag_data.handle.closest('.multirange-slider-range').find('.multirange-slider-handle').tooltip('show');
          e.preventDefault();
        }
      },
      
      _dragEnd: function(slider, e){
        if(slider.drag_data.handle){
          slider.drag_data.handle = null;
        
          if(slider.element){
            slider.element.trigger('change', [slider.value()]);
          }
        }
      },
      
      _snapValue: function(number){
        return Math.round(number * this.scale_factor) / this.scale_factor;
      },
      
      setIntervals: function(intervals){
        this.intervals = intervals;
        this._drawIntervals();
      },
      
      splitInterval: function(i, type){
        if(this.intervals.length === 0){
          var start = Math.min(this.max, this.min + 3),
              end = Math.min(this.max, start + 8);
          this.intervals.push(_.compact([start, end, type]));
        }
        else{
          i = (i && i !== 0) ? i : this.intervals.length - 1;
          var start = this.intervals[i][0],
              end = this.intervals[i][1],
              mid_low = this._snapValue((end + start)/2),
              mid_high = mid_low + this.step;
              
          this.intervals[i][1] = mid_low;
          this.intervals.push(_.compact([mid_high, end, type]));
          this.intervals.sort(sortManyArray);
        }
        
        this._drawIntervals();
        
        if(this.element){
          this.element.trigger('change', [this.value()]);
        }
      },
      
      combineInterval: function(i){
        if(this.intervals.length < 2){
          // we don't have any breaks to remove so... remove it all
          this.intervals.pop();
        }
        else{
          i = (i && i !== 0) ? i : this.intervals.length - 1;
          if(!this.intervals[i - 1]){
            i = i + 1;
          }
          
          var removed = this.intervals.splice(i-1, 2);
          this.intervals.push([removed[0][0], removed[1][1], removed[0][2]]);
          this.intervals.sort(sortManyArray);
        }
        
        this._drawIntervals();
                
        if(this.element){
          this.element.trigger('change', [this.value()]);
        }
      },
      
      value: function(){
        return this.intervals;
      },
      
      enable: function(){
        this.disabled = false;
        this.element.on('mousedown.' + this.unique_number, '.multirange-slider-handle', this._mousedown);
        $(document).on('mousemove.' + this.unique_number, this._mousemove);
        $(document).on('mouseup.' + this.unique_number, this._mouseup);
        this.element.removeClass('multirange-slider-disabled');
        setTimeout($.proxy(function(){
          this.element.find('.multirange-slider-handle').tooltip('show');
        }, this), 1)
      },
      
      disable: function(){
        this.disabled = true;
        this.element.off('mousedown.' + this.unique_number, '.multirange-slider-handle', this._mousedown);
        $(document).off('mousemove.' + this.unique_number, this._mousemove);
        $(document).off('mouseup.' + this.unique_number, this._mouseup);
        this.element.addClass('multirange-slider-disabled');
        setTimeout($.proxy(function(){
          this.element.find('.multirange-slider-handle').tooltip('hide');
        }, this), 1)
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
