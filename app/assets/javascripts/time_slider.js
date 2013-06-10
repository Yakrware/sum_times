$(function(){
  var translate_time = function(t){
    var pm = t > 12,
        t = pm ? t - 12 : t,
        hour = Math.floor(t),
        frac = t - hour,
        mins = frac * 60.0;
    return hour.toString() + ':' + ("00" + Math.round(mins).toString()).substr(-2) + (pm ? ' PM' : ' AM');
  }

  var time_slider = function(){
    var self = this;
    self.slider_start = 7;
    self.slider_stop = 18;
    self.slider_length = self.slider_stop - self.slider_start;

    // methods to draw the slider(s)
    $('[data-time-slider]').each(function(i){
      self.drawSlider($(this));
    });

    $('[data-time-slider] div').tooltip();

    // methods to detect manipulation
    $(document).on('mousedown', '.slider-handle', self.dragHandle)
  };

  time_slider.prototype.drawSlider = function(slider){
    var self = this,
        slider_start = this.slider_start,
        slider_stop = this.slider_stop,
        slider_length = this.slider_length;

    if(slider.hasClass('time-slider-labels')){
      this.drawLabels(slider);
    }

    $.each(slider.data('time-slider'), function(j, v){
      var div = $('<div/>', {
          class: 'slider-indicator',
          'data-toggle': 'tooltip',
          'title': translate_time(v.start) + ' - ' + translate_time(v.end)
        }),
        left = (100*(v.start - slider_start) / slider_length),
        right = (100*(slider_stop - v.end) / slider_length);

      div.css({
        left: left.toString() + '%',
        right: right.toString() + '%'
      });

      slider.append(div);

      if(slider.hasClass('editable')){
        var left_handle = $('<div/>', {
          class: 'slider-handle',
          'data-toggle': 'tooltip',
          'title': translate_time(v.start)
        }),
        right_handle = $('<div/>', {
          class: 'slider-handle',
          'data-toggle': 'tooltip',
          'title': translate_time(v.end)
        });
        left_handle.css({
          left: left.toString() + '%',
          right: (100 - left).toString() + '%'
        });
        right_handle.css({
          left: (100 - right).toString() + '%',
          right: right.toString() + '%'
        });

        slider.append(left_handle);
        slider.append(right_handle);
      }
    });
  };

  time_slider.prototype.drawLabels = function(slider){
    var labels = $('<div/>', {
      class: 'slider-labels'
    });

    for(var k = this.slider_start; k <= this.slider_stop; k += 2){
      var lbl = $('<div>' + translate_time(k) + '</div>');
      lbl.css({
        left: (100*(k - this.slider_start) / this.slider_length).toString() + '%',
        right: (100*(this.slider_stop - k) / this.slider_length).toString() + '%'
      });
      if(k == this.slider_stop){
        lbl.css({
          float: 'right',
          position: 'static'
        });
      }
      labels.append(lbl)
    }
    slider.append(labels);
  }

  time_slider.prototype.dragHandle = function(event){
    var startx = event.pageX;
    // mousemove and mouseup functions. declared as vars so we can remove them later
      mousemove = function(event){
        var diff = event.pageX - startx;
      },
      mouseup = function(){
      $(document).off('mousemove', mousemove);
      $(document).off('mouseup', mouseup);
    };

    // listen for mouse move and mouse up
    $(document).on('mousemove', mousemove);
    $(document).on('mouseup', mouseup);
  }

  TimeSlider = new time_slider();
})
