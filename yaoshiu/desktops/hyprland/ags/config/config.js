const entry = `${App.configDir}/ts/main.ts`
const outdir = '/tmp/ags'

const scss = `${App.configDir}/style/style.scss`
const css = `${outdir}/style/style.css`

await Utils.execAsync([
  'bun', 'build', entry,
  '--outdir', `${outdir}/js`,
  '--external', 'resource://*',
  '--external', 'gi://*',
]).then(print)
  .catch(print)

const main = await import(`file://${outdir}/js/main.js`)

await Utils.execAsync([
  'mkdir', '-p', `${outdir}/style`
]).then(print)
  .catch(print)

await Utils.execAsync([
  'sassc', scss, css
]).then(print)
  .catch(print)

Utils.monitorFile(
  `${App.configDir}/style`,

  () => {
    Utils.exec(`sassc ${scss} ${css}`)
    App.resetCss()
    App.applyCss(css)
  },
)

export default {
  ...main.default,
  style: css,
}
