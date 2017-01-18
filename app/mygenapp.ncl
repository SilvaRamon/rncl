<?xml version="1.0" encoding="ISO-8859-1"?>
<ncl id="ginga_bookmarks" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
  <head>
    <transitionBase>
      <transition id="tFade" type="fade" dur="0.7s" />
    </transitionBase>
    <regionBase>
      <region height="75px" id="screenReg" width="100px">
        <region id="video" zIndex="0" rnl-height="#screenReg.width" />
        <region top="15%" zIndex="1" id="botaoBookmark" rnl-height="#video.height" left="70%" />
        <region id="botaoInterat" right="5%" width="8%" top="5%" zIndex="1" rln-height="#livroReg.height" />
        <region top="0px" id="menu" height="100%" zIndex="1" left="60%" width="40%">
          <region id="titulo" top="0px" height="76px" zIndex="2" left="0px" width="100%" />
          <region top="76px" id="primeiroElm" height="130px" zIndex="2" left="0px" width="100%">
            <region id="livroReg" top="0px" height="130px" zIndex="3" left="0px" width="290px" />
            <region id="botaoReg" top="0px" height="130px" zIndex="3" left="290px" width="130px" />
          </region>
          <region top="206px" id="segundoElm" height="130px" zIndex="2" left="0px" width="100%">
            <region id="audioReg" top="0px" height="130px" zIndex="3" left="0px" width="290px" />
            <region id="botaoReg2" top="0px" height="130px" zIndex="3" left="290px" width="130px" />
          </region>
          <region id="videoMenor" top="0px" height="100%" zIndex="3" right="0px" width="60%" />
        </region>
      </region>
    </regionBase>
    <descriptorBase>
      <descriptor id="dVideo" region="video">
        <descriptorParam name="background" value="teal" />
      </descriptor>
      <descriptor id="dBotaoBookmark" explicitDur="8s" region="botaoBookmark" />
      <descriptor id="dBotaoBookmarked" explicitDur="4s" region="botaoBookmark" />
      <descriptor id="dBotaoInterat" region="botaoInterat">
        <descriptorParam name="fit" value="meet" />
      </descriptor>
      <descriptor id="dMenu" region="menu">
        <descriptorParam name="background" value="black" />
      </descriptor>
      <descriptor transOut="tFade" region="titulo" id="dTitulo" transIn="tFade">
        <descriptorParam name="fit" value="fill" />
      </descriptor>
      <descriptor id="dPrim" region="primeiroElm">
        <descriptorParam name="background" value="black" />
      </descriptor>
      <descriptor transOut="tFade" region="livroReg" id="dLivroReg" focusBorderWidth="3" focusBorderColor="white" selBorderColor="gray" moveUp="2" moveDown="2" transIn="tFade" focusIndex="1" />
      <descriptor transOut="tFade" region="botaoReg" id="dBotaoReg" transIn="tFade" />
      <descriptor id="dSeg" region="segundoElm">
        <descriptorParam name="background" value="black" />
      </descriptor>
      <descriptor transOut="tFade" region="audioReg" id="dAudioReg" focusBorderWidth="3" focusBorderColor="white" selBorderColor="gray" moveUp="1" moveDown="1" transIn="tFade" focusIndex="2" />
      <descriptor transOut="tFade" region="botaoReg2" id="dBotaoReg2" transIn="tFade" />
      <descriptor id="dVideoMenor" region="videoMenor" />
    </descriptorBase>
    <connectorBase>
      <causalConnector id="onBeginStart">
        <simpleCondition role="onBegin" />
        <simpleAction role="start" max="unbounded" qualifier="par" />
      </causalConnector>
      <causalConnector id="onBeginStart_delay">
        <connectorParam name="delay" />
        <simpleCondition role="onBegin" />
        <simpleAction role="start" max="unbounded" qualifier="par" delay="$delay" />
      </causalConnector>
      <causalConnector id="onKeySelectionStopStart">
        <connectorParam name="keyCode" />
        <simpleCondition role="onSelection" key="$keyCode" />
        <compoundAction operator="seq">
          <simpleAction role="stop" />
          <simpleAction role="start" max="unbounded" qualifier="par" />
        </compoundAction>
      </causalConnector>
      <causalConnector id="onEndStop">
        <simpleCondition role="onEnd" />
        <simpleAction role="stop" max="unbounded" qualifier="par" />
      </causalConnector>
      <causalConnector id="onKeySelectionSetStartStop">
        <connectorParam name="vKey" />
        <connectorParam name="vNewValue" />
        <simpleCondition role="onSelection" key="$vKey" />
        <compoundAction operator="par">
          <simpleAction role="set" value="$vNewValue" max="unbounded" />
          <simpleAction role="start" max="unbounded" />
          <simpleAction role="stop" max="unbounded" />
        </compoundAction>
      </causalConnector>
    </connectorBase>
  </head>
  <body>
    <port id="pInicio" component="mVideo" />
    <media id="mVideo" src="media/video.mp4" descriptor="dVideo">
      <property name="width" value="100%" />
      <property name="height" value="100%" />
      <property name="top" value="0%" />
    </media>
    <media id="mBotaoBookmark" src="media/add_bookmark_2.jpg" descriptor="dBotaoBookmark" />
    <media id="mBotaoBookmarked" src="media/add_bookmark.jpg" descriptor="dBotaoBookmarked" />
    <media id="mBotaoInterat" src="media/info_icon.png" descriptor="dBotaoInterat" />
    <media id="mTitulo" src="media/titulo_bookmarks.png" descriptor="dTitulo" />
    <media id="mLivroAdd" src="media/harpasselvagens_naomarked.jpg" descriptor="dLivroReg" />
    <media id="mLivroRem" src="media/harpasselvagens_marked.jpg" descriptor="dLivroReg" />
    <media id="mBotaoAdd" src="media/botao_add.jpg" descriptor="dBotaoReg" />
    <media id="mBotaoRem" src="media/botao_remover.jpg" descriptor="dBotaoReg" />
    <media id="mAudioAdd" src="media/marcopereira_naomarked.jpg" descriptor="dAudioReg" />
    <media id="mAudioRem" src="media/marcopereira_marked.jpg" descriptor="dAudioReg" />
    <media id="mBotaoAdd2" src="media/botao_add.jpg" descriptor="dBotaoReg2" />
    <media id="mBotaoRem2" src="media/botao_remover.jpg" descriptor="dBotaoReg2" />
    <link xconnector="onBeginStart_delay">
      <bind component="mVideo" role="onBegin" />
      <bind component="mBotaoBookmark" role="start">
        <bindParam name="delay" value="62s" />
      </bind>
      <bind component="mBotaoInterat" role="start">
        <bindParam name="delay" value="75s" />
      </bind>
    </link>
    <link xconnector="onKeySelectionStopStart">
      <bind component="mBotaoBookmark" role="onSelection">
        <bindParam name="keyCode" value="RED" />
      </bind>
      <bind component="mBotaoBookmark" role="stop" />
      <bind component="mBotaoBookmarked" role="start" />
    </link>
    <link xconnector="onKeySelectionSetStartStop">
      <bind component="mBotaoInterat" role="onSelection">
        <bindParam name="vKey" value="INFO" />
      </bind>
      <bind role="set" component="mVideo" interface="top">
        <bindParam name="vNewValue" value="40%" />
      </bind>
      <bind role="set" component="mVideo" interface="width">
        <bindParam name="vNewValue" value="60%" />
      </bind>
      <bind role="set" component="mVideo" interface="height">
        <bindParam name="vNewValue" value="60%" />
      </bind>
      <bind component="mBotaoInterat" role="stop" />
      <bind component="mTitulo" role="start" />
      <bind component="mLivroRem" role="start" />
      <bind component="mBotaoRem" role="start" />
      <bind component="mAudioAdd" role="start" />
      <bind component="mBotaoAdd2" role="start" />
    </link>
    <link id="lEnd" xconnector="onEndStop">
      <bind role="onEnd" component="mVideo" />
      <bind component="mBotaoInterat" role="stop" />
      <bind component="mTitulo" role="stop" />
      <bind component="mLivroRem" role="stop" />
      <bind component="mBotaoRem" role="stop" />
      <bind component="mAudioAdd" role="stop" />
      <bind component="mBotaoAdd2" role="stop" />
    </link>
  </body>
</ncl>
