
if((typeof Prototype=='undefined'))
      throw("ProgressBar requires the Prototype JavaScript framework >= 1.6");

ProgressBar = Class.create();

/** The inderterminate state */
ProgressBar.INDETERMINATE = 1;
ProgressBar.DETERMINATE = 1<<1;
ProgressBar.TRANSPARENCY = 1<<2;

ProgressBar.prototype =  {
	/** 
	 * Constructeur 
	 */
   initialize: function( container, options ) {
        this.container = container;
	    /**
	     * Defines progress bar default options
	     */
	    this.options = 	{
	    				style: ProgressBar.INDETERMINATE,
	    				color: {r: 38, g: 255, b: 38},
	    				colorEnd: null,
	    				classProgressBar: 'progressBar',
	    				minimum: 0,
	    				maximum: 100,
	 					selection: 0,
	 					setTimeoutDelay: 50,
	 					noIndeterminateIndicators: 10,
	 					widthIndicators: 6,
	 					IndeterminateIndicatorsSpeed: 5
	    			}
    	
    	// Set options
   		Object.extend( this.options, options ? options : {} );
   		
   		// Wait until the parent have a ancestors named "body" ;-)
   		new PeriodicalExecuter( this._waitForContainer.bind(this), 0.05);
    },
    
    /**
     * Returns the maximum value which the receiver will allow. 
     */
    getMaximum: function(){ return this.maximum; },
    
	/**
	 * Returns the minimum value which the receiver will allow. 
	 */  
	getMinimum: function(){ return this.minimum; },  
	          
	/**
	 * Returns the single 'selection' that is the receiver's position. 
	 */  
	getSelection: function(){ return this.selection; }, 
	          
	/**
	 * Sets the maximum value that the receiver will allow.  
	 */  
	setMaximum: function(value) { this.maximum = value; },
	          
	/**
	 * Sets the minimum value that the receiver will allow.   
	 */  
	setMinimum: function(value) { this.minimum = value; },
	          
	/**
	 * Sets the single 'selection' that is the receiver's position to the argument which must be greater than or equal to zero. 
	 */  
	setSelection: function(value) { if( value >= this.minimum &&  value <= this.maximum){this.selection = value; this._updateSelection();}},
	
	/**
	 * Returns true if the widget has been disposed, and false otherwise
	 */
	isDisposed: function(){
		return this.disposed;
	},
	
	/**
	 * Disposes the receiver and all its HTML Objects descendants.
	 */
	dispose: function(){
		if( !this.isDisposed() ){
			this.disposed = true;
			this.progressBar.parentNode.removeChild( this.progressBar );
		}
	},
	
    /**
     * Return the class identifier.
     */
    toString: function(){
    	return "ProgressBar";
    },
    
    /**
     * Wait until container have a body in his ancestor.
     */
     _waitForContainer: function(p){
        if( this.container.ancestors().include( $(document.body) )) {
            p.stop();
            // Initialise dhtml elements
   		    this._drawDhtmlElements();
       		
   		    // Set the pogress bar children
   		    this.progressIndicators = new Array();
       		
   		    // This widget is currently not disposed
   		    this.disposed = false;
       		
   		    // Set the progress bar values
   		    this.setMaximum( this.options.maximum );
   		    this.setMinimum( this.options.minimum );
   		    this.setSelection( this.options.selection );
       		
       		
   		    // If progress bar style is indeterminate stats effects
   		    if( ( this.options.style & ProgressBar.INDETERMINATE ) == ProgressBar.INDETERMINATE ){
   			    this.lastTime = new Date();
			    this._updateIndeterminate();
   		    }
        }
     },
    
	/**
	 * Call setSelection function recursively.
	 */
	_updateIndeterminate: function(){
		if( this.isDisposed() ){
			return;
		}
		this.setSelection( ( this.selection + 1 ) % this.maximum );
		setTimeout(this._updateIndeterminate.bind(this), this.options.setTimeoutDelay);
	},
	
	_updateSelection: function(){
		if( ( this.options.style & ProgressBar.INDETERMINATE ) == ProgressBar.INDETERMINATE ){
			this._updateSelectionIndeterminate();
		}else{
			var nbIndicatorsMax = Math.round( this.progressBarContent.clientWidth / this.options.widthIndicators );
			var nbIndicators = Math.round( nbIndicatorsMax * this.selection / ( this.maximum - this.minimum ) );
			
			var i = this.progressIndicators.length;
			while( this.progressIndicators.length < nbIndicators ){
				var element = this._createIndicator( ( i * ( this.options.widthIndicators + 1 ) ) + 'px' );
				this.progressIndicators[ this.progressIndicators.length ] = element;
				i++;
			}
			
			i = this.progressIndicators.length - 1;
			while( i >=0 && this.progressIndicators.length > nbIndicators ){
				var element = this.progressIndicators[ i ];
				this.progressIndicators[ i ] = null;
				this.progressIndicators.length --;
				this.progressBarContent.removeChild( element );
				i--;
			}
			
			// Met ≒ jour la couleur des indicateurs
			this._updateIndicatorsColor();
		}
	},
	
	_updateSelectionIndeterminate: function(){
		// Create progress bar indicators
		var i = 0;
		var r = parseInt( Math.random() * 10 );
		while( this.progressIndicators.length < this.options.noIndeterminateIndicators ){
			var element = this._createIndicator( );
			element.style.left = ( ( this.options.noIndeterminateIndicators - i + 1) * ( this.options.widthIndicators + 1 ) + r ) + 'px';
			
			if( ( this.options.style & ProgressBar.TRANSPARENCY ) == ProgressBar.TRANSPARENCY ){
				element.setOpacity( ( this.options.noIndeterminateIndicators - i ) / this.options.noIndeterminateIndicators );
			}
			
			this.progressIndicators[ this.progressIndicators.length ] = element;
			i++;
		}
		// Check the time past since last call
		var time = new Date();
		var delta = parseInt( ( time - this.lastTime ) / this.options.setTimeoutDelay ) + this.options.IndeterminateIndicatorsSpeed;
		this.lastTime = time;
			
		// Move progress bar indicators
		for(var i = this.progressIndicators.length - 1; i >= 0 ; i--){	
			var element = this.progressIndicators[i];
			var left = ( parseInt( element.style.left ) + delta ) % ( element.parentNode.clientWidth );
			if( !isNaN( left ) )
				element.style.left = left + 'px';
		}
	},
	
	_updateIndicatorsColor: function( color ){
		if( this.options.colorEnd != null ){
			var percent = this.selection / (this.maximum - this.minimum );
			if( typeof this.lastPercent == 'undefined' )
				this.lastPercent = percent;
			else if( percent > this.lastPercent && percent - this.lastPercent > 0.1 
					|| percent < this.lastPercent && this.lastPercent - percent  > 0.1
					){
				this.lastPercent = percent;
			}else{
				return;
			}
			
			var currentColor = {
				r: parseInt( this.options.color.r < this.options.colorEnd.r ? 
					this.options.color.r + ( this.options.colorEnd.r - this.options.color.r ) * percent
					: this.options.color.r - ( this.options.color.r - this.options.colorEnd.r) * percent
					)
				,
				g: parseInt( this.options.color.g < this.options.colorEnd.g ? 
					this.options.color.g + ( this.options.colorEnd.g - this.options.color.g ) * percent
					: this.options.color.g - ( this.options.color.g - this.options.colorEnd.g) * percent
					)
				,
				b: parseInt( this.options.color.b < this.options.colorEnd.b ? 
					this.options.color.b + ( this.options.colorEnd.b - this.options.color.b ) * percent
					: this.options.color.b - ( this.options.color.b - this.options.colorEnd.b) * percent
					)
			};
			var colorString = 'rgb(' + currentColor.r + ',' + currentColor.g + ',' + currentColor.b + ')';
			this.progressBarContent.childElements().each( function(i){
				i.childElements().each( function(e){
					e.style.backgroundColor = colorString;
				})
			});
		}
	},
	
	/**
	 * Draw an indicator.
	 */
	_createIndicator: function( left ){
			var element = this._createElement( ['absolute', null, left, this.options.widthIndicators + 'px', '100%', null, this.progressBarContent ]);
			
			var bgColor = 'rgb(' + this.options.color.r + ',' + this.options.color.g + ',' + this.options.color.b + ')';
			if( this.options.colorEnd != null && ( this.options.style & ProgressBar.DETERMINATE ) == ProgressBar.DETERMINATE){
				var percent = this.selection / (this.maximum - this.minimum );
				var currentColor = {
					r: parseInt( this.options.color.r < this.options.colorEnd.r ? 
						this.options.color.r + ( this.options.colorEnd.r - this.options.color.r ) * percent
						: this.options.color.r - ( this.options.color.r - this.options.colorEnd.r) * percent
						)
					,
					g: parseInt( this.options.color.g < this.options.colorEnd.g ? 
						this.options.color.g + ( this.options.colorEnd.g - this.options.color.g ) * percent
						: this.options.color.g - ( this.options.color.g - this.options.colorEnd.g) * percent
						)
					,
					b: parseInt( this.options.color.b < this.options.colorEnd.b ? 
						this.options.color.b + ( this.options.colorEnd.b - this.options.color.b ) * percent
						: this.options.color.b - ( this.options.color.b - this.options.colorEnd.b) * percent
						)
				};
				bgColor = 'rgb(' + currentColor.r + ',' + currentColor.g + ',' + currentColor.b + ')';
			}
			var height = parseInt( this.progressBarContent.clientHeight / 6 );
			var filtersParams = [
				['absolute', '0px', null, '100%', height + 'px', bgColor, element, 0.4],
				['absolute', height + 'px', null, '100%', height + 'px', bgColor, element, 0.5],
				['absolute', ( 2 * height ) + 'px', null, '100%', height + 'px', bgColor, element, 0.6],
				['absolute', ( 3 * height ) + 'px', null, '100%', height + 'px', bgColor, element, 0.7],
				['absolute', ( 4 * height ) + 'px', null, '100%', height + 'px', bgColor, element, 0.7],
				['absolute', ( 5 * height ) + 'px', null, '100%', height + 'px', bgColor, element, 0.6],
				['absolute', ( 6 * height ) + 'px', null, '100%', height + 'px', bgColor, element, 0.5]
			];
			this._createElements(filtersParams);		
			return element;
	},
	
 	/**
 	 * Draw an html container.
 	 */
    _drawDhtmlElements: function( ){
    	this.progressBar = new Element('div', {'class' : this.options.classProgressBar});
		this.container.appendChild( this.progressBar );
		
		var size = this.progressBar.getDimensions();
		
		this.progressBarContent = this._createElement(['absolute', '2px', '3px', (size.width - 6) + 'px', (size.height - 6) + 'px', null, this.progressBar]);
		this.progressBarContent.style.overflow = 'hidden';
		
		var borderParams = [
			// Border top 1
			['absolute', '0px', '1px', '1px', '1px', 'rgb(172, 171, 167)', this.progressBar],
			['absolute', '0px', '2px', '1px', '1px', 'rgb(127, 126, 125)', this.progressBar],
			['absolute', '0px', '3px', (size.width - 5) + 'px', '1px', 'rgb(104, 104, 104)', this.progressBar],
			// Border top 2
			['absolute', '1px', '0px', '1px', '1px', 'rgb(172, 171, 167)', this.progressBar],
			['absolute', '1px', '1px', '1px', '1px', 'rgb(119, 119, 119)', this.progressBar],
			['absolute', '1px', '2px', (size.width - 3) + 'px', '1px', 'rgb(190, 190, 190)', this.progressBar],
			['absolute', '1px', (size.width - 3) + 'px', '1px', '1px', 'rgb(104, 104, 104)', this.progressBar],
			['absolute', '1px', (size.width - 2) + 'px', '1px', '1px', 'rgb(179, 179, 179)', this.progressBar],
			// Border top 3
			['absolute', '2px', '0px', '1px', '1px', 'rgb(127, 126, 125)', this.progressBar],
			['absolute', '2px', '1px', '2px', '1px', 'rgb(190, 190, 190)', this.progressBar],
			['absolute', '2px', '3px', (size.width - 6) + 'px', '1px', 'rgb(239, 239, 239)', this.progressBar],
			['absolute', '2px', (size.width - 3) + 'px', '1px', '1px', 'rgb(190, 190, 190)', this.progressBar],
			['absolute', '2px', (size.width - 2) + 'px', '1px', '1px', 'rgb(129, 129, 129)', this.progressBar],
			// Border left
			['absolute', '3px', '0px', '1px', (size.height - 6) + 'px', 'rgb(104, 104, 104)', this.progressBar],
			['absolute', '3px', '1px', '1px', (size.height - 6) + 'px', 'rgb(190, 190, 190)', this.progressBar],
			// Border right
			['absolute', '3px', (size.width - 1) + 'px', '1px', (size.height - 6) + 'px', 'rgb(104, 104, 104)', this.progressBar],
			['absolute', '3px', (size.width - 2) + 'px', '1px', (size.height - 6) + 'px', 'rgb(190, 190, 190)', this.progressBar],
			// Border bottom 1
			['absolute', (size.height - 1) + 'px', '1px', '1px', '1px', 'rgb(239, 239, 239)', this.progressBar],
			['absolute', (size.height - 1) + 'px', '2px', '1px', '1px', 'rgb(127, 126, 125)', this.progressBar],
			['absolute', (size.height - 1) + 'px', '3px', (size.width - 5) + 'px', '1px', 'rgb(104, 104, 104)', this.progressBar],
			// Border bottom 2
			['absolute', (size.height - 2) + 'px', '0px', '1px', '1px', 'rgb(172, 171, 166)', this.progressBar],
			['absolute', (size.height - 2) + 'px', '1px', '1px', '1px', 'rgb(119, 119, 119)', this.progressBar],
			['absolute', (size.height - 2) + 'px', '2px', (size.width - 3) + 'px', '1px', 'rgb(190, 190, 190)', this.progressBar],
			['absolute', (size.height - 2) + 'px', (size.width - 3) + 'px', '1px', '1px', 'rgb(104, 104, 104)', this.progressBar],
			['absolute', (size.height - 2) + 'px', (size.width - 2) + 'px', '1px', '1px', 'rgb(179, 179, 179)', this.progressBar],
			// Border bottom 3
			['absolute', (size.height - 3) + 'px', '0px', '1px', '1px', 'rgb(127, 126, 125)', this.progressBar],
			['absolute', (size.height - 3) + 'px', '1px', '2px', '1px', 'rgb(190, 190, 190)', this.progressBar],
			['absolute', (size.height - 3) + 'px', '3px', (size.width - 6) + 'px', '1px', 'rgb(239, 239, 239)', this.progressBar],
			['absolute', (size.height - 3) + 'px', (size.width - 3) + 'px', '1px', '1px', 'rgb(190, 190, 190)', this.progressBar],
			['absolute', (size.height - 3) + 'px', (size.width - 2) + 'px', '1px', '1px', 'rgb(129, 129, 129)', this.progressBar]
		];
		this._createElements(borderParams);		
	},
	
	/**
	 * Create elements defined in param.
	 */
	_createElements: function( elementsParams ){
		for(var i = 0; i < elementsParams.length; i++){
			this._createElement(elementsParams[i]);
		}
	},
	/**
	 * Create an html div element.
	 * elementParams[0]: position,
	 * elementParams[1]: top,
	 * elementParams[2]: left,
	 * elementParams[3]: width,
	 * elementParams[4]: height,
	 * elementParams[5]: backgroundColor,
	 * elementParams[6]: parentNode,
	 */
	_createElement: function( elementParams ){
		var element = new Element('div');
		var style = element.style;
		if( elementParams[0] != null )
			style.position = elementParams[0];
			
		if( elementParams[1] != null )
			style.top = elementParams[1];
			
		if( elementParams[2] != null )
			style.left = elementParams[2];
			
		if( elementParams[3] != null )
			style.width = elementParams[3];
			
		if( elementParams[4] != null )
			style.height = elementParams[4];
			
		if( elementParams[5] != null )
			style.backgroundColor = elementParams[5];
			
		if( elementParams[6] != null )
			elementParams[6].appendChild( element );
			
		if( elementParams[7] != null )
			element.setOpacity( elementParams[7] );
		style.fontSize = '0px';
		return element;
	}
 };

