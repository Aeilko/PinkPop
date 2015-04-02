Dom = require 'dom'
Ui = require 'ui'
Page = require 'page'
Plugin = require 'plugin'
Photo = require 'photo'
Obs = require 'obs'

exports.render = ->
	p = Page.state.get(0)
	if p == 'map'
		# Kaart weergeven
		Dom.h2 "Placeholder tot er een kaart is"
		
		contain = Obs.create false
		showPicture({key: Plugin.resourceUri('map.jpg')})
	else if p == 'artiesten'
		p2 = Page.state.get(1)
		if p2 == 'v'
			# Individuele Artiest bekijken
			
		else if p2 == 'vr'
			Dom.div !->
				
				showArtiestBlok({naam: 'Muse', podium: 'Main Stage', link: 'muse', image: 'muse.jpg', bg: '#e6007e'})
				showArtiestBlok({naam: 'Elbow', podium: 'Main Stage', link: 'elbow', image: 'elbow.jpg', bg: '#e6007e'})
				showArtiestBlok({naam: 'George Ezra', podium: 'Main Stage', link: 'george-ezra', image: 'george-ezra.jpg', bg: '#e6007e'})
				showArtiestBlok({naam: 'Slash', podium: '3FM Stage', link: 'slash', image: 'slash.jpg', bg: '#e6007e'})
				showArtiestBlok({naam: 'Faith No More', podium: '3FM Stage', link: 'faith-no-more', image: 'faith-no-more.jpg', bg: '#e6007e'})
				showArtiestBlok({naam: 'Shaka Ponk', podium: '3FM Stage', link: 'shaka-ponk', image: 'shaka-ponk.jpg', bg: '#e6007e'})
				showArtiestBlok({naam: 'Above & Beyond', podium: 'Brand Bier Stage', link: 'above-and-beyond', image: 'above-and-beyond.jpg', bg: '#e6007e'})
				showArtiestBlok({naam: 'Paloma Faith', podium: 'Brand Bier Stage', link: 'paloma-faith', image: 'paloma-faith.jpg', bg: '#e6007e'})
				showArtiestBlok({naam: 'Gavin James', podium: 'Brand Bier Stage', link: 'gavin-jones', image: 'gavin-james.jpg', bg: '#e6007e'})
				showArtiestBlok({naam: 'The Amazing Laserbeams', podium: 'Brand Bier Stage', link: 'amazing-laserbeams', image: 'amazing-laserbeams.jpg', bg: '#e6007e'})
				showArtiestBlok({naam: 'DJ\'s Waxfiend & Prime', podium: 'Stage 4', link: 'djs-waxfiend-and-prime', image: 'djs-waxfiend-and-prime.jpg', bg: '#e6007e'})
				showArtiestBlok({naam: 'Pop Evil', podium: 'Stage 4', link: 'pop-evil', image: 'pop-evil.jpg', bg: '#e6007e'})
				showArtiestBlok({naam: 'Aurora', podium: 'Stage 4', link: 'aurora', image: 'aurora.jpg', bg: '#e6007e'})
				showArtiestBlok({naam: 'Coasts', podium: 'Stage 4', link: 'coasts', image: 'coasts.jpg', bg: '#e6007e'})
		
		else if p2 == 'za'
			Dom.div !->
				showArtiestBlok({naam: 'Robbie Williams', podium: 'Main Stage', link: 'robbie-williams', image: 'robbie-williams.jpg', bg: '#792182'})
				showArtiestBlok({naam: 'The Script', podium: 'Main Stage', link: 'the-script', image: 'the-script.jpg', bg: '#792182'})
				showArtiestBlok({naam: 'Anouk', podium: 'Main Stage', link: 'anouk', image: 'anouk.jpg', bg: '#792182'})
				showArtiestBlok({naam: 'Avicii', podium: '3FM Stage', link: 'avicii', image: 'avicii.jpg', bg: '#792182'})
		
		else if p2 == 'zo'
			Dom.div !->
				showArtiestBlok({naam: 'Foo Fighters', podium: 'Main Stage', link: 'foo-fighters', image: 'foo-fighters.jpg', bg: '#b4b415'})
				showArtiestBlok({naam: 'Pharrell', podium: 'Main Stage', link: 'pharrel', image: 'pharrell.jpg', bg: '#b4b415'})
				showArtiestBlok({naam: 'OneRepublic', podium: 'Main Stage', link: 'onerepublic', image: 'one-republic.jpg', bg: '#b4b415'})
				showArtiestBlok({naam: 'Sam Smith', podium: '3FM Stage', link: 'sam-smith', image: 'sam-smith.jpg', bg: '#b4b415'})
		
		else
			Ui.list !->
				Dom.h2 "Artiesten"
				Ui.item !->
					Dom.text "Vrijdag"
					Dom.onTap !->
						Page.nav ['artiesten', 'vr']
				Ui.item !->
					Dom.text "Zaterdag"
					Dom.onTap !->
						Page.nav ['artiesten', 'za']
				Ui.item !->
					Dom.text "Zondag"
					Dom.onTap !->
						Page.nav ['artiesten', 'zo']
	else
		Ui.list !->
			Dom.h2 "Menu"
			Ui.item !->
				Dom.text "Artiesten"
				Dom.onTap !->
					Page.nav 'artiesten'
			Ui.item !->
				Dom.text "Kaart"
				Dom.onTap !->
					Page.nav 'map'
					


showArtiestBlok = (opts) !->
	Dom.div !->
		Dom.onTap !->
			Page.nav ['artiesten', 'v', opts.link]
		Dom.style
			width: '100%'
			height: '150px'
			display: 'inline-block'
			backgroundImage: 'url(' + Plugin.resourceUri(opts.image) + ')'
			backgroundSize: 'cover'
			backgroundPosition: '50% 50%'
			overflow: 'hidden'
			position: 'relative'
			marginBottom: '5px'
		
		Dom.div !->
			Dom.text "" + opts.naam + " - " + opts.podium
			Dom.style
				padding: '5px'
				width: '100%'
				display: 'block'
				position: 'absolute'
				bottom: '0'
				backgroundColor: opts.bg
				color: 'white'
				fontWeight: 'bold'


# Source: https://github.com/Happening/Core/blob/master/photoview.client.coffee
showPicture = (opts) !->
	Dom.div !->
		bgE = Dom.get()
		pageW = Page.width()
		pageH = Page.height()
		imgE = largeImgE = imgW = imgH = imgP = showW = minW = false
		offW = offH = 0
		Dom.style
			position: 'relative'
			height: pageW + 'px'
			width: pageW + 'px'
			backgroundColor: '#333'
			overflow: 'hidden'
		Dom.img !->
			imgE = Dom.get()
			Dom.style
				visibility: 'hidden'
				position: 'absolute'
			Dom.prop
				src: opts.key
			Dom.on 'dragstart', (e) !-> e.kill()
			Dom.setOnLoad !->
				return if !largeImgE # somehow largeImgE loaded faster
				init()

		Dom.img !->
			largeImgE = Dom.get()
			Dom.style
				visibility: 'hidden'
				position: 'absolute'
			setTimeout !->
				# allow the UI to settle before downloading larger version
				largeImgE.prop
					src: opts.key
			,500
			Dom.on 'dragstart', (e) !-> e.kill()
			Dom.setOnLoad !->
				imgE.style display: 'none'
				imgE = largeImgE
				init()

		round = (v) -> (0|(v*10+0.05))/10

		update = !->
			showW = Math.max(showW,minW)
			scale = showW/imgW
			showH = imgH*scale

			offW = round if (empty=pageW-showW)>=0 then empty/2 else Math.max(empty,Math.min(0,offW))
			offH = round if (empty=pageW-showH)>=0 then empty/2 else Math.max(empty,Math.min(0,offH))

			bgE.style
				height: Math.ceil(Math.max(pageW,Math.min(pageH,showH+offH)))+'px'

			imgE.style
				visibility: 'visible'
				_transformOrigin: '0 0'
				_transform: "translate3d(#{offW}px,#{offH}px,0) scale3d(#{scale},#{scale},1)"

		init = !->
			imgW = imgE.prop('width')
			imgH = imgE.prop('height')
			imgP = imgH / imgW
			nw = imgW/Math.max(imgW,imgH)*pageW
			if !showW or Math.abs(showW-nw)<5
				showW = minW = nw
			update()

		startOffset = startScale = startWidth = null
		tapTime = 0
		zoomMode = null

		Dom.trackTouch (touches...) ->
			return "bubble" unless imgW

			if touches.length==1
				now = Date.now()
				touch = touches[0]
				if touch.op&4
					if touch.start + 300 > now and Math.abs(touch.x)+Math.abs(touch.y)<10 # it's a tap
						if zoomMode?
							if showW>minW
								showW = minW
							else
								showW *= 3
								offW = touch.xc - startOffset.x + (startOffset.x/startWidth) * (startWidth-showW)
								offH = touch.yc - startOffset.y + (startOffset.y/startWidth) * (startWidth-showW)
						else
							tapTime = now
					zoomMode = null
				else if touch.op&1 and tapTime+600 > now
					zoomMode = 1
				if zoomMode?
					zoomMode = Math.pow(0.99,-touch.y)

			remaining = (touch for touch in touches when !(touch.op&4))

			center = {x:0, y:0}
			for touch in remaining
				center.x += touch.xc/remaining.length
				center.y += touch.yc/remaining.length

			if remaining.length==2
				xd = remaining[0].xc - remaining[1].xc
				yd = remaining[0].yc - remaining[1].yc
				dist = Math.sqrt(xd*xd + yd*yd)
			else
				dist = 1

			for touch in touches when touch.op&5 # any starting/ending touches?
				# store a new baseline
				startOffset = {x: center.x-offW, y: center.y-offH}
				startScale = showW / dist
				startWidth = showW
				break

			showW = startScale * (zoomMode ? dist)
			offW = center.x - startOffset.x + (startOffset.x/startWidth) * (startWidth-showW)
			offH = center.y - startOffset.y + (startOffset.y/startWidth) * (startWidth-showW)
			update()

			showW==minW && !zoomMode? # scrollable if zoomed out in touchstart
		,bgE

		opts.content?()