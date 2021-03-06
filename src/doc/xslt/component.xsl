<xsl:stylesheet version="2.0" xmlns:pkg="http://expath.org/ns/pkg"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:comp="https://github.com/Quodatum/app-doc/component"
	>
	<!-- 
	convert components.xml to bootstrap html match on /components for catalog 
	assumes bootstrap,
	        angular,
	        $scope.scrollTo,
	        
	-->
	<xsl:template match="/comp:components">
	<div>
	<h2>  Components <span class="label label-default">
                        <xsl:value-of select="count(comp:cmp)" />
                    </span>
      </h2>
                
		<div class="row">
			<div class="col-md-2">

				<xsl:call-template name="list">
					<xsl:with-param name="cmps" select="comp:cmp" />
				</xsl:call-template>

			</div>
			<div class="col-md-10">
				
				<div>
					<xsl:apply-templates select="comp:cmp">
						<xsl:sort select="lower-case(@name)" />
					</xsl:apply-templates>
				</div>
				<h2>Errors</h2>
				<xsl:for-each select="//depends[not(. =//comp:cmp/@name)]">
					<span class="label label-danger">
						<xsl:value-of select="." />
					</span>
				</xsl:for-each>
			</div>
		</div>
		</div>
	</xsl:template>
	
	
	<!-- convert package.xml to bootstrap html -->
	<xsl:template match="/pkg:package">
		<xsl:variable name="cmps"
			select="doc('../data/doc/components.xml')//comp:cmp" />
		<xsl:variable name="used" select="pkg:dependency" />
		<xsl:variable name="found" select="$cmps[@name=$used/@name]" />
		<xsl:variable name="missing" select="$used[not(@name=$cmps/@name)]" />
		<div>
		<h2>
                    Components used
                    <span class="label label-default">
                        <xsl:value-of select="count($used)" />
                    </span>
                    <small class="pull-right">
                        package.xml
                        <a href="../../doc/app/{@abbrev}/client/components?fmt=xml"
                            target="dn">
                            <i class="glyphicon glyphicon-save"></i>
                        </a>
                    </small>
                </h2>
		<div class="row">
			<div class="col-md-2">
				<xsl:call-template name="list">
					<xsl:with-param name="cmps" select="$found" />
				</xsl:call-template>
				<xsl:if test="$missing">
					<div>
						Missing
						<span class="badge">
							<xsl:value-of select="count($missing)" />
						</span>
					</div>
					<xsl:for-each select="$missing">
						<div>
							<xsl:value-of select="@name" />
						</div>
					</xsl:for-each>
				</xsl:if>
			</div>
			<div class="col-md-10" >
				
				<xsl:apply-templates select="$found">
					<xsl:sort select="lower-case(@name)" />
				</xsl:apply-templates>
			</div>
		</div>
	   </div>
	</xsl:template>


	<xsl:template match="comp:cmp">
		<div class="panel panel-default">
			<div class="panel-heading">
				<h4 class="panel-title">
					<a class="anchor" id="cmp-{@name}"></a>
					
					<a ui-sref="component.item({{name:'{@name}'}})">
                        <xsl:value-of select="@name" />
                    </a>
                    <span class="badge">
                        <xsl:value-of select="comp:runat" />
                    </span>
					<span class="pull-right">
						<a href="{comp:home}" target="benchx-doc" class="badge" title="{@name} {comp:home}">
							<i class="fa fa-external-link"></i>
							Home
						</a>
						<a ng-click="scrollTo('cmp-{@name}')">#</a>
					</span>
				</h4>
			</div>
			<div class="panel-body">
				<p>
					<xsl:value-of select="comp:tagline" />
				</p>
				<xsl:apply-templates select="comp:licence" />

				<div>
					Used by:
					<xsl:call-template name="list">
						<xsl:with-param name="cmps"
							select="//comp:cmp[depends=current()/@name]" />
					</xsl:call-template>
				</div>
				<div>
					Depends on:
					<xsl:call-template name="list">
						<xsl:with-param name="cmps"
							select="//comp:cmp[@name=current()/depends]" />
					</xsl:call-template>
				</div>
				<h5>
					Versions
					<span class="badge ">
						<xsl:value-of select="count(comp:release)" />
					</span>
				</h5>
				<ul>
					<xsl:apply-templates select="comp:release" />
				</ul>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="@version">
		<span class="badge">
			<xsl:value-of select="." />
		</span>
	</xsl:template>

	<xsl:template match="comp:licence">
		<span>
			Licence:
			<span class="badge">
				<xsl:value-of select="." />
			</span>
		</span>
	</xsl:template>


	<xsl:template match="comp:release">
		<li>
			<xsl:apply-templates select="@version" />
			<xsl:apply-templates select="comp:cdn|comp:local" />
		</li>
	</xsl:template>

	<xsl:template match="comp:cdn">
		<div>
			CDN
			<xsl:value-of select="@type" />
			<xsl:value-of select="." />
		</div>
	</xsl:template>

	<xsl:template match="comp:local">
		<div>
			Local
			<xsl:value-of select="@type" />
			<xsl:value-of select="." />
		</div>
	</xsl:template>

	<xsl:template name="list">
		<xsl:param name="cmps" />
		<div class="list-group">
			<xsl:for-each select="$cmps">
				<xsl:sort select="lower-case(@name)" />
				<xsl:apply-templates select="." mode="link" />
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template match="comp:cmp" mode="link">
		<a ng-click="scrollTo('cmp-{@name}')" title="{normalize-space(comp:tagline)}"
			class="list-group-item">
			<xsl:value-of select="@name" />
		</a>
	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>