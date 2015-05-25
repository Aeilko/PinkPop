Dom = require 'dom'
Ui = require 'ui'
Page = require 'page'
Plugin = require 'plugin'
Photo = require 'photo'
Obs = require 'obs'
Db = require 'db'
Server = require 'server'

exports.render = ->
	p = Page.state.get(0)
	if p == 'map'
		# Kaart weergeven
		Dom.h2 "Placeholder tot er een kaart is"
		
		contain = Obs.create false
		showPicture({key: Plugin.resourceUri('map.jpg')})
	else if p == 'artiesten'
		p2 = Page.state.get(1)		
		if p2 == 'vr' || p2 == 'za' || p2 == 'zo'
			p3 = Page.state.get(2)
			if Db.shared.get('artiesten', p3) != undefined
				showArtiest(p3)			
			else
				dag = Db.shared.get("dagen", p2)
				Db.shared.iterate 'artiesten', (artiest) !->
					if artiest.get("dag") == p2
						podium = Db.shared.get("podia", artiest.get("podium"))
						
						
						Dom.div !->
							Dom.onTap !->
								Page.nav ['artiesten', p2, artiest.key()]
							Dom.style
								width: '100%'
								height: '150px'
								display: 'inline-block'
								backgroundImage: 'url(' + Plugin.resourceUri(artiest.get("img")) + ')'
								backgroundSize: 'cover'
								backgroundPosition: '50% 50%'
								overflow: 'hidden'
								position: 'relative'
								marginBottom: '5px'
							
							Dom.div !->
								Dom.text "" + artiest.get('naam') + " - " + podium.naam
								Dom.style
									padding: '5px'
									width: '100%'
									display: 'block'
									position: 'absolute'
									bottom: '0'
									backgroundColor: dag.kleur
									color: 'white'
									fontWeight: 'bold'
						
						#showArtiestBlok({naam: artiest.get('naam'), podium: podium.naam, link: artiest.key(), image: artiest.get("img"), bg: dag.kleur})
				,(artiest) -> [artiest.get("podium"), -artiest.get("start")]
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
	
	else if p == 'tijdschema'
		p2 = Page.state.get(1)
		if p2 == "vr" || p2 == "za" || p2 == "zo"
			p3 = Page.state.get(2)
			if Db.shared.get('artiesten', p3) != undefined
				showArtiest(p3)
			else
				dag = Db.shared.get('dagen', p2)
				
				# Titel
				Dom.div !->
					Dom.text "" + dag.naam
					Dom.style
						width: '100%'
						height: '25px'
						paddingTop: '5px'
						backgroundColor: '' + dag.kleur
						color: 'white'
						fontWeight: 'bold'
						textAlign: 'center'
				
				# Blokschema
				Dom.div !->
					Dom.style
						backgroundColor: '' + dag.kleur
						width: '100%'
						height: 'auto'
					
					# Header voor tijd
					Dom.div !->
							Dom.style
								width: '25%'
								paddingTop: '5px'
								paddingBottom: '5px'
								display: 'inline-block'
								color: '#ffe500'
								textAlign: 'center'
								textTransform: 'uppercase'
								fontWeight: 'bold'
								fontSize: '100%'
								backgroundColor: '#000'
							Dom.text "Tijd"
					# Header voor podia
					Db.shared.iterate 'podia', (podium) !->
						Dom.div !->
							Dom.style
								width: 'calc(25% - 1px)'
								paddingTop: '5px'
								paddingBottom: '5px'
								borderLeftWidth: '1px'
								borderLeftStyle: 'solid'
								borderLeftColor: '' + dag.kleur
								display: 'inline-block'
								color: '#ffe500'
								textAlign: 'center'
								textTransform: 'uppercase'
								fontWeight: 'bold'
								fontSize: '100%'
								backgroundColor: '#000'
							Dom.text podium.get('naam')
					
					# Tijd blok
					Dom.div !->
						Dom.style
							width: '25%'
							display: 'block'
							float: 'left'
						
						if p2 == 'vr'
							i = 15
						else
							i = 13
						loop
							Dom.div !->
								Dom.style
									height:'50px'
									width: '100%'
								Dom.div !->
									Dom.style
										width: '50px'
										textAlign: 'center'
										color: '#FFF'
										backgroundColor: '#222221'
										marginLeft: 'calc(50% - 25px)'
									Dom.text "" + i + ":00"
							
							i++
							break if i > 23
					
					# Podia
					Db.shared.iterate 'podia', (podium) !->
						if p2 == 'vr'
							start = 15
						else
							start = 13
						
						Dom.div !->
							Dom.style
								width: 'calc(25% - 1px)'
								height: (24-start)*50 + 'px'
								display: 'block'
								float: 'left'
								borderLeftWidth: '1px'
								borderLeftStyle: 'solid'
								borderLeftColor: '#000'
								position: 'relative'
						
							# Iterate through artists
							Db.shared.iterate 'artiesten', (artiest) !->
								#Dom.text "Podium \"" + p2 + "\" - \"" + artiest.get("dag") + "\""
								if artiest.get("dag") == p2 && Db.shared.get("podia", artiest.get('podium'), "naam") == podium.get("naam")
									Dom.div !->
										if Db.shared.get("wantToSee", artiest.key(), Plugin.userId()) == 1
											color = "#00FF00"
										else
											color = "#FF0000"
											
										Dom.onTap !->
											Server.call 'wantToSee', artiest.key()
										Dom.style
											backgroundColor: '' + color
											minHeight: (artiest.get('stop')-artiest.get('start'))*50 + 'px'
											width: '90%'
											marginLeft: '5%'
											marginTop: (artiest.get('start')-start)*50 + 'px'
											position: 'absolute';
										Dom.div !->
											Dom.text artiest.get('start') + " - " + artiest.get('stop')
											Dom.style
												padding: '2px'
												margin: '0'
												fontSize: '50%'
												fontWeight: 'bold'
												textAlign: 'center'
												color: '#000'
										Dom.div !->
											Dom.text artiest.get('naam')
											Dom.onTap !->
												Page.nav [p, p2, artiest.key()]
											Dom.style
												padding: '2px'
												textAlign: 'center'
												color: '#000'
												fontSize: '75%'
												fontWeight: 'bold'
												textTransform: 'uppercase'
					
					# Clear both
					Dom.div !->
						Dom.style
							clear: 'both'
					
		else
			Ui.list !->
				Dom.h2 "Tijdschema"
				Ui.item !->
					Dom.text "Vrijdag"
					Dom.onTap !->
						Page.nav ['tijdschema', 'vr']
				Ui.item !->
					Dom.text "Zaterdag"
					Dom.onTap !->
						Page.nav ['tijdschema', 'za']
				Ui.item !->
					Dom.text "Zondag"
					Dom.onTap !->
						Page.nav ['tijdschema', 'zo']
	
	else
		Ui.list !->
			Dom.h2 "Menu"
			Ui.item !->
				Dom.text "Artiesten"
				Dom.onTap !->
					Page.nav 'artiesten'
			Ui.item !->
				Dom.text "Tijdschema"
				Dom.onTap !->
					Page.nav 'tijdschema'
			Ui.item !->
				Dom.text "Kaart"
				Dom.onTap !->
					Page.nav 'map'
					


showArtiest = (id) !->
	artiest = Db.shared.get('artiesten', id)
	Dom.div !->
		Dom.style
			width: '100%'
			height: '250px'
			backgroundImage: 'url(' + Plugin.resourceUri(artiest.img) + ')'
			backgroundSize: 'cover'
			#backgroundPosition: '50% 50%'
			display: 'block'
	
	Dom.div !->
		Dom.h1 artiest.naam
		Dom.text artiest.text
		Dom.style
			padding: '10px'
			backgroundColor: '#FFF'
			marginBottom: '10px'
	
	Ui.list !->
		Dom.h2 "Wie wil dit zien?"
		total = 0
		wantTo = Db.shared.ref('wantToSee', id);
		wantTo.iterate (see) !->
			if see.get() == 1
				total++
				Ui.item !->
					Ui.avatar Plugin.userAvatar(see.key())
					Dom.div !->
						Dom.style
							marginLeft: '10px'
						Dom.text Plugin.userName(see.key())
		if total == 0
			Ui.item !->
				Dom.style
					fontStyle: 'italic'
				Dom.text "Niemand"
				

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